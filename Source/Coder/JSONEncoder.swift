//
//  JSONEncoder.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/22.
//

import Foundation

#if DEBUG
// for test

#if arch(i386) || arch(arm)
internal protocol _JSONStringDictionaryEncodableMarker { }
#else
private protocol _JSONStringDictionaryEncodableMarker { }
#endif

extension Dictionary : _JSONStringDictionaryEncodableMarker where Key == String, Value: Encodable { }

open class JSONEncoder {
	// MARK: Options
	/// The formatting of the output JSON data.
	public struct OutputFormatting : OptionSet {
		/// The format's default value.
		public let rawValue: UInt
		
		/// Creates an OutputFormatting value with the given raw value.
		public init(rawValue: UInt) {
			self.rawValue = rawValue
		}
		
		/// Produce human-readable JSON with indented output.
		public static let prettyPrinted = OutputFormatting(rawValue: 1 << 0)
		
		/// Produce JSON with dictionary keys sorted in lexicographic order.
		@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)
		public static let sortedKeys    = OutputFormatting(rawValue: 1 << 1)
		
		/// By default slashes get escaped ("/" → "\/", "http://apple.com/" → "http:\/\/apple.com\/")
		/// for security reasons, allowing outputted JSON to be safely embedded within HTML/XML.
		/// In contexts where this escaping is unnecessary, the JSON is known to not be embedded,
		/// or is intended only for display, this option avoids this escaping.
		@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
		public static let withoutEscapingSlashes = OutputFormatting(rawValue: 1 << 3)
	}
	
	/// The strategy to use for encoding `Date` values.
	public enum DateEncodingStrategy {
		/// Defer to `Date` for choosing an encoding. This is the default strategy.
		case deferredToDate
		
		/// Encode the `Date` as a UNIX timestamp (as a JSON number).
		case secondsSince1970
		
		/// Encode the `Date` as UNIX millisecond timestamp (as a JSON number).
		case millisecondsSince1970
		
		/// Encode the `Date` as an ISO-8601-formatted string (in RFC 3339 format).
		@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
		case iso8601
		
		/// Encode the `Date` as a string formatted by the given formatter.
		case formatted(DateFormatter)
		
		/// Encode the `Date` as a custom value encoded by the given closure.
		///
		/// If the closure fails to encode a value into the given encoder, the encoder will encode an empty automatic container in its place.
		case custom((Date, Encoder) throws -> Void)
	}
	
	/// The strategy to use for encoding `Data` values.
	public enum DataEncodingStrategy {
		/// Defer to `Data` for choosing an encoding.
		case deferredToData
		
		/// Encoded the `Data` as a Base64-encoded string. This is the default strategy.
		case base64
		
		/// Encode the `Data` as a custom value encoded by the given closure.
		///
		/// If the closure fails to encode a value into the given encoder, the encoder will encode an empty automatic container in its place.
		case custom((Data, Encoder) throws -> Void)
	}
	
	/// The strategy to use for non-JSON-conforming floating-point values (IEEE 754 infinity and NaN).
	public enum NonConformingFloatEncodingStrategy {
		/// Throw upon encountering non-conforming values. This is the default strategy.
		case `throw`
		
		/// Encode the values using the given representation strings.
		case convertToString(positiveInfinity: String, negativeInfinity: String, nan: String)
	}
	
	/// The strategy to use for automatically changing the value of keys before encoding.
	public enum KeyEncodingStrategy {
		/// Use the keys specified by each type. This is the default strategy.
		case useDefaultKeys
		
		/// Convert from "camelCaseKeys" to "snake_case_keys" before writing a key to JSON payload.
		///
		/// Capital characters are determined by testing membership in `CharacterSet.uppercaseLetters` and `CharacterSet.lowercaseLetters` (Unicode General Categories Lu and Lt).
		/// The conversion to lower case uses `Locale.system`, also known as the ICU "root" locale. This means the result is consistent regardless of the current user's locale and language preferences.
		///
		/// Converting from camel case to snake case:
		/// 1. Splits words at the boundary of lower-case to upper-case
		/// 2. Inserts `_` between words
		/// 3. Lowercases the entire string
		/// 4. Preserves starting and ending `_`.
		///
		/// For example, `oneTwoThree` becomes `one_two_three`. `_oneTwoThree_` becomes `_one_two_three_`.
		///
		/// - Note: Using a key encoding strategy has a nominal performance cost, as each string key has to be converted.
		case convertToSnakeCase
		
		/// Provide a custom conversion to the key in the encoded JSON from the keys specified by the encoded types.
		/// The full path to the current encoding position is provided for context (in case you need to locate this key within the payload). The returned key is used in place of the last component in the coding path before encoding.
		/// If the result of the conversion is a duplicate key, then only one value will be present in the result.
		case custom((_ codingPath: [CodingKey]) -> CodingKey)
		
		fileprivate static func _convertToSnakeCase(_ stringKey: String) -> String {
			guard !stringKey.isEmpty else { return stringKey }
			
			var words : [Range<String.Index>] = []
			// The general idea of this algorithm is to split words on transition from lower to upper case, then on transition of >1 upper case characters to lowercase
			//
			// myProperty -> my_property
			// myURLProperty -> my_url_property
			//
			// We assume, per Swift naming conventions, that the first character of the key is lowercase.
			var wordStart = stringKey.startIndex
			var searchRange = stringKey.index(after: wordStart)..<stringKey.endIndex
			
			// Find next uppercase character
			while let upperCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.uppercaseLetters, options: [], range: searchRange) {
				let untilUpperCase = wordStart..<upperCaseRange.lowerBound
				words.append(untilUpperCase)
				
				// Find next lowercase character
				searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
				guard let lowerCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange) else {
					// There are no more lower case letters. Just end here.
					wordStart = searchRange.lowerBound
					break
				}
				
				// Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase letters that we should treat as its own word
				let nextCharacterAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
				if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
					// The next character after capital is a lower case character and therefore not a word boundary.
					// Continue searching for the next upper case for the boundary.
					wordStart = upperCaseRange.lowerBound
				} else {
					// There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
					let beforeLowerIndex = stringKey.index(before: lowerCaseRange.lowerBound)
					words.append(upperCaseRange.lowerBound..<beforeLowerIndex)
					
					// Next word starts at the capital before the lowercase we just found
					wordStart = beforeLowerIndex
				}
				searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
			}
			words.append(wordStart..<searchRange.upperBound)
			let result = words.map({ (range) in
				return stringKey[range].lowercased()
			}).joined(separator: "_")
			return result
		}
	}
	
	/// The output format to produce. Defaults to `[]`.
	open var outputFormatting: OutputFormatting = []
	
	/// The strategy to use in encoding dates. Defaults to `.deferredToDate`.
	open var dateEncodingStrategy: DateEncodingStrategy = .deferredToDate
	
	/// The strategy to use in encoding binary data. Defaults to `.base64`.
	open var dataEncodingStrategy: DataEncodingStrategy = .base64
	
	/// The strategy to use in encoding non-conforming numbers. Defaults to `.throw`.
	open var nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy = .throw
	
	/// The strategy to use for encoding keys. Defaults to `.useDefaultKeys`.
	open var keyEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys
	
	/// Contextual user-provided information for use during encoding.
	open var userInfo: [CodingUserInfoKey : Any] = [:]
	
	/// Options set on the top-level encoder to pass down the encoding hierarchy.
	fileprivate struct _Options {
		let dateEncodingStrategy: DateEncodingStrategy
		let dataEncodingStrategy: DataEncodingStrategy
		let nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy
		let keyEncodingStrategy: KeyEncodingStrategy
		let userInfo: [CodingUserInfoKey : Any]
	}
	
	/// The options set on the top-level encoder.
	fileprivate var options: _Options {
		return _Options(dateEncodingStrategy: dateEncodingStrategy,
						dataEncodingStrategy: dataEncodingStrategy,
						nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy,
						keyEncodingStrategy: keyEncodingStrategy,
						userInfo: userInfo)
	}
	
	// MARK: - Constructing a JSON Encoder
	/// Initializes `self` with default strategies.
	public init() {}
	
	// MARK: - Encoding Values
	/// Encodes the given top-level value and returns its JSON representation.
	///
	/// - parameter value: The value to encode.
	/// - returns: A new `Data` value containing the encoded JSON data.
	/// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
	/// - throws: An error if any value throws an error during encoding.
	open func encode<T : Encodable>(_ value: T) throws -> Data {
		let encoder = __JSONEncoder(options: self.options)
		
		guard let topLevel = try encoder.box_(value) else {
			throw EncodingError.invalidValue(value,
											 EncodingError.Context(codingPath: [], debugDescription: "Top-level \(T.self) did not encode any values."))
		}
		
		let writingOptions = JSONSerialization.WritingOptions(rawValue: self.outputFormatting.rawValue).union(.fragmentsAllowed)
		do {
			return try JSONSerialization.data(withJSONObject: topLevel, options: writingOptions)
		} catch {
			throw EncodingError.invalidValue(value,
											 EncodingError.Context(codingPath: [], debugDescription: "Unable to encode the given top-level value to JSON.", underlyingError: error))
		}
	}
}

// MARK: - __JSONEncoder
// NOTE: older overlays called this class _JSONEncoder.
// The two must coexist without a conflicting ObjC class name, so it
// was renamed. The old name must not be used in the new runtime.
private class __JSONEncoder : Encoder {
	// MARK: Properties
	/// The encoder's storage.
	var storage: _JSONEncodingStorage
	
	/// Options set on the top-level encoder.
	let options: JSONEncoder._Options
	
	/// The path to the current point in encoding.
	public var codingPath: [CodingKey]
	
	/// Contextual user-provided information for use during encoding.
	public var userInfo: [CodingUserInfoKey : Any] {
		return self.options.userInfo
	}
	
	// MARK: - Initialization
	/// Initializes `self` with the given top-level encoder options.
	init(options: JSONEncoder._Options, codingPath: [CodingKey] = []) {
		self.options = options
		self.storage = _JSONEncodingStorage()
		self.codingPath = codingPath
	}
	
	/// Returns whether a new element can be encoded at this coding path.
	///
	/// `true` if an element has not yet been encoded at this coding path; `false` otherwise.
	var canEncodeNewValue: Bool {
		// Every time a new value gets encoded, the key it's encoded for is pushed onto the coding path (even if it's a nil key from an unkeyed container).
		// At the same time, every time a container is requested, a new value gets pushed onto the storage stack.
		// If there are more values on the storage stack than on the coding path, it means the value is requesting more than one container, which violates the precondition.
		//
		// This means that anytime something that can request a new container goes onto the stack, we MUST push a key onto the coding path.
		// Things which will not request containers do not need to have the coding path extended for them (but it doesn't matter if it is, because they will not reach here).
		return self.storage.count == self.codingPath.count
	}
	
	// MARK: - Encoder Methods
	public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
		// If an existing keyed container was already requested, return that one.
		let topContainer: NSMutableDictionary
		if self.canEncodeNewValue {
			// We haven't yet pushed a container at this level; do so here.
			topContainer = self.storage.pushKeyedContainer()
		} else {
			guard let container = self.storage.containers.last as? NSMutableDictionary else {
				preconditionFailure("Attempt to push new keyed encoding container when already previously encoded at this path.")
			}
			
			topContainer = container
		}
		
		let container = _JSONKeyedEncodingContainer<Key>(referencing: self, codingPath: self.codingPath, wrapping: topContainer)
		return KeyedEncodingContainer(container)
	}
	
	public func unkeyedContainer() -> UnkeyedEncodingContainer {
		// If an existing unkeyed container was already requested, return that one.
		let topContainer: NSMutableArray
		if self.canEncodeNewValue {
			// We haven't yet pushed a container at this level; do so here.
			topContainer = self.storage.pushUnkeyedContainer()
		} else {
			guard let container = self.storage.containers.last as? NSMutableArray else {
				preconditionFailure("Attempt to push new unkeyed encoding container when already previously encoded at this path.")
			}
			
			topContainer = container
		}
		
		return _JSONUnkeyedEncodingContainer(referencing: self, codingPath: self.codingPath, wrapping: topContainer)
	}
	
	public func singleValueContainer() -> SingleValueEncodingContainer {
		return self
	}
}

// MARK: - Encoding Storage and Containers
private struct _JSONEncodingStorage {
	// MARK: Properties
	/// The container stack.
	/// Elements may be any one of the JSON types (NSNull, NSNumber, NSString, NSArray, NSDictionary).
	private(set) var containers: [NSObject] = []
	
	// MARK: - Initialization
	/// Initializes `self` with no containers.
	init() {}
	
	// MARK: - Modifying the Stack
	var count: Int {
		return self.containers.count
	}
	
	mutating func pushKeyedContainer() -> NSMutableDictionary {
		let dictionary = NSMutableDictionary()
		self.containers.append(dictionary)
		return dictionary
	}
	
	mutating func pushUnkeyedContainer() -> NSMutableArray {
		let array = NSMutableArray()
		self.containers.append(array)
		return array
	}
	
	mutating func push(container: __owned NSObject) {
		self.containers.append(container)
	}
	
	mutating func popContainer() -> NSObject {
		precondition(!self.containers.isEmpty, "Empty container stack.")
		return self.containers.popLast()!
	}
}

// MARK: - Encoding Containers
private struct _JSONKeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
	typealias Key = K
	
	// MARK: Properties
	/// A reference to the encoder we're writing to.
	private let encoder: __JSONEncoder
	
	/// A reference to the container we're writing to.
	private let container: NSMutableDictionary
	
	/// The path of coding keys taken to get to this point in encoding.
	private(set) public var codingPath: [CodingKey]
	
	// MARK: - Initialization
	/// Initializes `self` with the given references.
	init(referencing encoder: __JSONEncoder, codingPath: [CodingKey], wrapping container: NSMutableDictionary) {
		self.encoder = encoder
		self.codingPath = codingPath
		self.container = container
	}
	
	// MARK: - Coding Path Operations
	private func _converted(_ key: CodingKey) -> CodingKey {
		switch encoder.options.keyEncodingStrategy {
		case .useDefaultKeys:
			return key
		case .convertToSnakeCase:
			let newKeyString = JSONEncoder.KeyEncodingStrategy._convertToSnakeCase(key.stringValue)
			return _JSONKey(stringValue: newKeyString, intValue: key.intValue)
		case .custom(let converter):
			return converter(codingPath + [key])
		}
	}
	
	// MARK: - KeyedEncodingContainerProtocol Methods
	public mutating func encodeNil(forKey key: Key) throws {
		self.container[_converted(key).stringValue] = NSNull()
	}
	public mutating func encode(_ value: Bool, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: Int, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: Int8, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: Int16, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: Int32, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: Int64, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: UInt, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: UInt8, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: UInt16, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: UInt32, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: UInt64, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	public mutating func encode(_ value: String, forKey key: Key) throws {
		self.container[_converted(key).stringValue] = self.encoder.box(value)
	}
	
	public mutating func encode(_ value: Float, forKey key: Key) throws {
		// Since the float may be invalid and throw, the coding path needs to contain this key.
		self.encoder.codingPath.append(key)
		defer { self.encoder.codingPath.removeLast() }
		self.container[_converted(key).stringValue] = try self.encoder.box(value)
	}
	
	public mutating func encode(_ value: Double, forKey key: Key) throws {
		// Since the double may be invalid and throw, the coding path needs to contain this key.
		self.encoder.codingPath.append(key)
		defer { self.encoder.codingPath.removeLast() }
		self.container[_converted(key).stringValue] = try self.encoder.box(value)
	}
	
	public mutating func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
		self.encoder.codingPath.append(key)
		defer { self.encoder.codingPath.removeLast() }
		self.container[_converted(key).stringValue] = try self.encoder.box(value)
	}
	
	public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
		let containerKey = _converted(key).stringValue
		let dictionary: NSMutableDictionary
		if let existingContainer = self.container[containerKey] {
			precondition(
				existingContainer is NSMutableDictionary,
				"Attempt to re-encode into nested KeyedEncodingContainer<\(Key.self)> for key \"\(containerKey)\" is invalid: non-keyed container already encoded for this key"
			)
			dictionary = existingContainer as! NSMutableDictionary
		} else {
			dictionary = NSMutableDictionary()
			self.container[containerKey] = dictionary
		}
		
		self.codingPath.append(key)
		defer { self.codingPath.removeLast() }
		
		let container = _JSONKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)
		return KeyedEncodingContainer(container)
	}
	
	public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
		let containerKey = _converted(key).stringValue
		let array: NSMutableArray
		if let existingContainer = self.container[containerKey] {
			precondition(
				existingContainer is NSMutableArray,
				"Attempt to re-encode into nested UnkeyedEncodingContainer for key \"\(containerKey)\" is invalid: keyed container/single value already encoded for this key"
			)
			array = existingContainer as! NSMutableArray
		} else {
			array = NSMutableArray()
			self.container[containerKey] = array
		}
		
		self.codingPath.append(key)
		defer { self.codingPath.removeLast() }
		return _JSONUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath, wrapping: array)
	}
	
	public mutating func superEncoder() -> Encoder {
		return __JSONReferencingEncoder(referencing: self.encoder, key: _JSONKey.super, convertedKey: _converted(_JSONKey.super), wrapping: self.container)
	}
	
	public mutating func superEncoder(forKey key: Key) -> Encoder {
		return __JSONReferencingEncoder(referencing: self.encoder, key: key, convertedKey: _converted(key), wrapping: self.container)
	}
}

private struct _JSONUnkeyedEncodingContainer : UnkeyedEncodingContainer {
	// MARK: Properties
	/// A reference to the encoder we're writing to.
	private let encoder: __JSONEncoder
	
	/// A reference to the container we're writing to.
	private let container: NSMutableArray
	
	/// The path of coding keys taken to get to this point in encoding.
	private(set) public var codingPath: [CodingKey]
	
	/// The number of elements encoded into the container.
	public var count: Int {
		return self.container.count
	}
	
	// MARK: - Initialization
	/// Initializes `self` with the given references.
	init(referencing encoder: __JSONEncoder, codingPath: [CodingKey], wrapping container: NSMutableArray) {
		self.encoder = encoder
		self.codingPath = codingPath
		self.container = container
	}
	
	// MARK: - UnkeyedEncodingContainer Methods
	public mutating func encodeNil()             throws { self.container.add(NSNull()) }
	public mutating func encode(_ value: Bool)   throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: Int)    throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: Int8)   throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: Int16)  throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: Int32)  throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: Int64)  throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: UInt)   throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: UInt8)  throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: UInt16) throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: UInt32) throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: UInt64) throws { self.container.add(self.encoder.box(value)) }
	public mutating func encode(_ value: String) throws { self.container.add(self.encoder.box(value)) }
	
	public mutating func encode(_ value: Float)  throws {
		// Since the float may be invalid and throw, the coding path needs to contain this key.
		self.encoder.codingPath.append(_JSONKey(index: self.count))
		defer { self.encoder.codingPath.removeLast() }
		self.container.add(try self.encoder.box(value))
	}
	
	public mutating func encode(_ value: Double) throws {
		// Since the double may be invalid and throw, the coding path needs to contain this key.
		self.encoder.codingPath.append(_JSONKey(index: self.count))
		defer { self.encoder.codingPath.removeLast() }
		self.container.add(try self.encoder.box(value))
	}
	
	public mutating func encode<T : Encodable>(_ value: T) throws {
		self.encoder.codingPath.append(_JSONKey(index: self.count))
		defer { self.encoder.codingPath.removeLast() }
		self.container.add(try self.encoder.box(value))
	}
	
	public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
		self.codingPath.append(_JSONKey(index: self.count))
		defer { self.codingPath.removeLast() }
		
		let dictionary = NSMutableDictionary()
		self.container.add(dictionary)
		
		let container = _JSONKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)
		return KeyedEncodingContainer(container)
	}
	
	public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		self.codingPath.append(_JSONKey(index: self.count))
		defer { self.codingPath.removeLast() }
		
		let array = NSMutableArray()
		self.container.add(array)
		return _JSONUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath, wrapping: array)
	}
	
	public mutating func superEncoder() -> Encoder {
		return __JSONReferencingEncoder(referencing: self.encoder, at: self.container.count, wrapping: self.container)
	}
}

extension __JSONEncoder : SingleValueEncodingContainer {
	// MARK: - SingleValueEncodingContainer Methods
	private func assertCanEncodeNewValue() {
		precondition(self.canEncodeNewValue, "Attempt to encode value through single value container when previously value already encoded.")
	}
	
	public func encodeNil() throws {
		assertCanEncodeNewValue()
		self.storage.push(container: NSNull())
	}
	
	public func encode(_ value: Bool) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: Int) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: Int8) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: Int16) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: Int32) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: Int64) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: UInt) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: UInt8) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: UInt16) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: UInt32) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: UInt64) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: String) throws {
		assertCanEncodeNewValue()
		self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: Float) throws {
		assertCanEncodeNewValue()
		try self.storage.push(container: self.box(value))
	}
	
	public func encode(_ value: Double) throws {
		assertCanEncodeNewValue()
		try self.storage.push(container: self.box(value))
	}
	
	public func encode<T : Encodable>(_ value: T) throws {
		assertCanEncodeNewValue()
		try self.storage.push(container: self.box(value))
	}
}

// MARK: - Concrete Value Representations
private extension __JSONEncoder {
	/// Returns the given value boxed in a container appropriate for pushing onto the container stack.
	func box(_ value: Bool)   -> NSObject { return NSNumber(value: value) }
	func box(_ value: Int)    -> NSObject { return NSNumber(value: value) }
	func box(_ value: Int8)   -> NSObject { return NSNumber(value: value) }
	func box(_ value: Int16)  -> NSObject { return NSNumber(value: value) }
	func box(_ value: Int32)  -> NSObject { return NSNumber(value: value) }
	func box(_ value: Int64)  -> NSObject { return NSNumber(value: value) }
	func box(_ value: UInt)   -> NSObject { return NSNumber(value: value) }
	func box(_ value: UInt8)  -> NSObject { return NSNumber(value: value) }
	func box(_ value: UInt16) -> NSObject { return NSNumber(value: value) }
	func box(_ value: UInt32) -> NSObject { return NSNumber(value: value) }
	func box(_ value: UInt64) -> NSObject { return NSNumber(value: value) }
	func box(_ value: String) -> NSObject { return NSString(string: value) }
	
	func box(_ float: Float) throws -> NSObject {
		guard !float.isInfinite && !float.isNaN else {
			guard case let .convertToString(positiveInfinity: posInfString,
											negativeInfinity: negInfString,
											nan: nanString) = self.options.nonConformingFloatEncodingStrategy else {
												throw EncodingError._invalidFloatingPointValue(float, at: codingPath)
			}
			
			if float == Float.infinity {
				return NSString(string: posInfString)
			} else if float == -Float.infinity {
				return NSString(string: negInfString)
			} else {
				return NSString(string: nanString)
			}
		}
		
		return NSNumber(value: float)
	}
	
	func box(_ double: Double) throws -> NSObject {
		guard !double.isInfinite && !double.isNaN else {
			guard case let .convertToString(positiveInfinity: posInfString,
											negativeInfinity: negInfString,
											nan: nanString) = self.options.nonConformingFloatEncodingStrategy else {
												throw EncodingError._invalidFloatingPointValue(double, at: codingPath)
			}
			
			if double == Double.infinity {
				return NSString(string: posInfString)
			} else if double == -Double.infinity {
				return NSString(string: negInfString)
			} else {
				return NSString(string: nanString)
			}
		}
		
		return NSNumber(value: double)
	}
	
	func box(_ date: Date) throws -> NSObject {
		switch self.options.dateEncodingStrategy {
		case .deferredToDate:
			// Must be called with a surrounding with(pushedKey:) call.
			// Dates encode as single-value objects; this can't both throw and push a container, so no need to catch the error.
			try date.encode(to: self)
			return self.storage.popContainer()
			
		case .secondsSince1970:
			return NSNumber(value: date.timeIntervalSince1970)
			
		case .millisecondsSince1970:
			return NSNumber(value: 1000.0 * date.timeIntervalSince1970)
			
		case .iso8601:
			if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
				return NSString(string: _iso8601Formatter.string(from: date))
			} else {
				fatalError("ISO8601DateFormatter is unavailable on this platform.")
			}
			
		case .formatted(let formatter):
			return NSString(string: formatter.string(from: date))
			
		case .custom(let closure):
			let depth = self.storage.count
			do {
				try closure(date, self)
			} catch {
				// If the value pushed a container before throwing, pop it back off to restore state.
				if self.storage.count > depth {
					let _ = self.storage.popContainer()
				}
				
				throw error
			}
			
			guard self.storage.count > depth else {
				// The closure didn't encode anything. Return the default keyed container.
				return NSDictionary()
			}
			
			// We can pop because the closure encoded something.
			return self.storage.popContainer()
		}
	}
	
	func box(_ data: Data) throws -> NSObject {
		switch self.options.dataEncodingStrategy {
		case .deferredToData:
			// Must be called with a surrounding with(pushedKey:) call.
			let depth = self.storage.count
			do {
				try data.encode(to: self)
			} catch {
				// If the value pushed a container before throwing, pop it back off to restore state.
				// This shouldn't be possible for Data (which encodes as an array of bytes), but it can't hurt to catch a failure.
				if self.storage.count > depth {
					let _ = self.storage.popContainer()
				}
				
				throw error
			}
			
			return self.storage.popContainer()
			
		case .base64:
			return NSString(string: data.base64EncodedString())
			
		case .custom(let closure):
			let depth = self.storage.count
			do {
				try closure(data, self)
			} catch {
				// If the value pushed a container before throwing, pop it back off to restore state.
				if self.storage.count > depth {
					let _ = self.storage.popContainer()
				}
				
				throw error
			}
			
			guard self.storage.count > depth else {
				// The closure didn't encode anything. Return the default keyed container.
				return NSDictionary()
			}
			
			// We can pop because the closure encoded something.
			return self.storage.popContainer()
		}
	}
	
	func box(_ dict: [String : Encodable]) throws -> NSObject? {
		let depth = self.storage.count
		let result = self.storage.pushKeyedContainer()
		do {
			for (key, value) in dict {
				self.codingPath.append(_JSONKey(stringValue: key, intValue: nil))
				defer { self.codingPath.removeLast() }
				result[key] = try box(value)
			}
		} catch {
			// If the value pushed a container before throwing, pop it back off to restore state.
			if self.storage.count > depth {
				let _ = self.storage.popContainer()
			}
			
			throw error
		}
		
		// The top container should be a new container.
		guard self.storage.count > depth else {
			return nil
		}
		
		return self.storage.popContainer()
	}
	
	func box(_ value: Encodable) throws -> NSObject {
		return try self.box_(value) ?? NSDictionary()
	}
	
	// This method is called "box_" instead of "box" to disambiguate it from the overloads. Because the return type here is different from all of the "box" overloads (and is more general), any "box" calls in here would call back into "box" recursively instead of calling the appropriate overload, which is not what we want.
	func box_(_ value: Encodable) throws -> NSObject? {
		// Disambiguation between variable and function is required due to
		// issue tracked at: https://bugs.swift.org/browse/SR-1846
		let type = Swift.type(of: value)
		if type == Date.self || type == NSDate.self {
			// Respect Date encoding strategy
			return try self.box((value as! Date))
		} else if type == Data.self || type == NSData.self {
			// Respect Data encoding strategy
			return try self.box((value as! Data))
		} else if type == URL.self || type == NSURL.self {
			// Encode URLs as single strings.
			return self.box((value as! URL).absoluteString)
		} else if type == Decimal.self || type == NSDecimalNumber.self {
			// JSONSerialization can natively handle NSDecimalNumber.
			return (value as! NSDecimalNumber)
		} else if value is _JSONStringDictionaryEncodableMarker {
			return try self.box(value as! [String : Encodable])
		}
		
		// The value should request a container from the __JSONEncoder.
		let depth = self.storage.count
		do {
			try value.encode(to: self)
		} catch {
			// If the value pushed a container before throwing, pop it back off to restore state.
			if self.storage.count > depth {
				let _ = self.storage.popContainer()
			}
			
			throw error
		}
		
		// The top container should be a new container.
		guard self.storage.count > depth else {
			return nil
		}
		
		return self.storage.popContainer()
	}
}

// MARK: - __JSONReferencingEncoder
/// __JSONReferencingEncoder is a special subclass of __JSONEncoder which has its own storage, but references the contents of a different encoder.
/// It's used in superEncoder(), which returns a new encoder for encoding a superclass -- the lifetime of the encoder should not escape the scope it's created in, but it doesn't necessarily know when it's done being used (to write to the original container).
// NOTE: older overlays called this class _JSONReferencingEncoder.
// The two must coexist without a conflicting ObjC class name, so it
// was renamed. The old name must not be used in the new runtime.
private class __JSONReferencingEncoder : __JSONEncoder {
	// MARK: Reference types.
	/// The type of container we're referencing.
	private enum Reference {
		/// Referencing a specific index in an array container.
		case array(NSMutableArray, Int)
		
		/// Referencing a specific key in a dictionary container.
		case dictionary(NSMutableDictionary, String)
	}
	
	// MARK: - Properties
	/// The encoder we're referencing.
	let encoder: __JSONEncoder
	
	/// The container reference itself.
	private let reference: Reference
	
	// MARK: - Initialization
	/// Initializes `self` by referencing the given array container in the given encoder.
	init(referencing encoder: __JSONEncoder, at index: Int, wrapping array: NSMutableArray) {
		self.encoder = encoder
		self.reference = .array(array, index)
		super.init(options: encoder.options, codingPath: encoder.codingPath)
		
		self.codingPath.append(_JSONKey(index: index))
	}
	
	/// Initializes `self` by referencing the given dictionary container in the given encoder.
	init(referencing encoder: __JSONEncoder, key: CodingKey, convertedKey: __shared CodingKey, wrapping dictionary: NSMutableDictionary) {
		self.encoder = encoder
		self.reference = .dictionary(dictionary, convertedKey.stringValue)
		super.init(options: encoder.options, codingPath: encoder.codingPath)
		
		self.codingPath.append(key)
	}
	
	// MARK: - Coding Path Operations
	override var canEncodeNewValue: Bool {
		// With a regular encoder, the storage and coding path grow together.
		// A referencing encoder, however, inherits its parents coding path, as well as the key it was created for.
		// We have to take this into account.
		return self.storage.count == self.codingPath.count - self.encoder.codingPath.count - 1
	}
	
	// MARK: - Deinitialization
	// Finalizes `self` by writing the contents of our storage to the referenced encoder's storage.
	deinit {
		let value: Any
		switch self.storage.count {
		case 0: value = NSDictionary()
		case 1: value = self.storage.popContainer()
		default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
		}
		
		switch self.reference {
		case .array(let array, let index):
			array.insert(value, at: index)
			
		case .dictionary(let dictionary, let key):
			dictionary[NSString(string: key)] = value
		}
	}
}

#endif
