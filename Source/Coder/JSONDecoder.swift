//
//  JSONDecoder.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/22.
//

import Foundation

private extension Dictionary where Key == String, Value == Any {
	subscript(mainKey key: Key, from decoder: __JSONDecoder) -> Value? {
		if let value = self[key], !(value is NSNull) { return value }
		guard let attirbute = decoder.dealingModel.decodeAttributes[key] else {
			if let value = decoder.dealingModel.defaltDecodeJSON[key] {
				return value
			}
			
			return nil
		}
		if let keys = (attirbute as? AlterCodingKey)?.alterKeys {
			for key in keys {
				if let value = self[key] { return value }
			}
		}
		
		return NSNull()
	}
}

/// 这部分代码来自原生
extension DecodingError {
	internal static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
		let description = "Expected to decode \(expectation) but found \(_typeDescription(of: reality)) instead."
		return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
	}
	private static func _typeDescription(of value: Any) -> String {
		if value is NSNull {
			return "a null value"
		} else if value is NSNumber /* FIXME: If swift-corelibs-foundation isn't updated to use NSNumber, this check will be necessary: || value is Int || value is Double */ {
			return "a number"
		} else if value is String {
			return "a string/data"
		} else if value is [Any] {
			return "an array"
		} else if value is [String : Any] {
			return "a dictionary"
		} else {
			return "\(type(of: value))"
		}
	}
}

////// A marker protocol used to determine whether a value is a `String`-keyed `Dictionary`
/// containing `Encodable` values (in which case it should be exempt from key conversion strategies).
///
/// NOTE: The architecture and environment check is due to a bug in the current (2018-08-08) Swift 4.2
/// runtime when running on i386 simulator. The issue is tracked in https://bugs.swift.org/browse/SR-8276
/// Making the protocol `internal` instead of `private` works around this issue.
/// Once SR-8276 is fixed, this check can be removed and the protocol always be made private.
#if arch(i386) || arch(arm)
internal protocol _JSONStringDictionaryEncodableMarker { }
#else
private protocol _JSONStringDictionaryEncodableMarker { }
#endif

extension Dictionary : _JSONStringDictionaryEncodableMarker where Key == String, Value: Encodable { }

/// A marker protocol used to determine whether a value is a `String`-keyed `Dictionary`
/// containing `Decodable` values (in which case it should be exempt from key conversion strategies).
///
/// The marker protocol also provides access to the type of the `Decodable` values,
/// which is needed for the implementation of the key conversion strategy exemption.
///
/// NOTE: Please see comment above regarding SR-8276
#if arch(i386) || arch(arm)
internal protocol _JSONStringDictionaryDecodableMarker {
	static var elementType: Decodable.Type { get }
}
#else
private protocol _JSONStringDictionaryDecodableMarker {
	static var elementType: Decodable.Type { get }
}
#endif

extension Dictionary : _JSONStringDictionaryDecodableMarker where Key == String, Value: Decodable {
	static var elementType: Decodable.Type { return Value.self }
}

// patch begin
func _decode<T: HappyCodable>(_ type: T.Type, from data: Any) throws -> T {
	let decoder = __JSONDecoder(referencing: data, as: type, decodeOption: T.decodeOption)
	guard var value = try decoder.unbox(as: type) else {
		throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: [], debugDescription: "The given data did not contain a top-level value."))
	}
	value.didFinishMapping()
	return value
}
// patch end

// MARK: - __JSONDecoder
// NOTE: older overlays called this class _JSONDecoder. The two must
// coexist without a conflicting ObjC class name, so it was renamed.
// The old name must not be used in the new runtime.
@usableFromInline
class __JSONDecoder : Decoder {
	// MARK: Properties
	/// The decoder's storage.
	fileprivate var storage: _JSONDecodingStorage
	@usableFromInline
	var dealingModels: [ModelCache] = []
	
	var dealingModel: ModelCache {
		dealingModels.last!
	}
	
	/* patch begin
	/// Options set on the top-level decoder.
	let options: JSONDecoder.Options
	patch end */
	// patch begin
	let options: HappyCodableDecodeOption
	// patch end
	
	/// The path to the current point in encoding.
	fileprivate(set) public var codingPath: [CodingKey] = []
	
	// patch begin
	/// Contextual user-provided information for use during encoding.
	public var userInfo: [CodingUserInfoKey: Any] = [:]
	
	// MARK: - Initialization
	/// Initializes `self` with the given top-level container and options.
	init(referencing container: Any, as type: Any.Type, at codingPath: [CodingKey] = [], decodeOption: HappyCodableDecodeOption) {
		self.storage = _JSONDecodingStorage()
		self.storage.push(container: container)
		self.codingPath = codingPath
		self.options = decodeOption
		
		pushDealingModel(type: type)
		Thread.decoder = { [weak self] in self }
	}
	deinit {
		Thread.decoder = nil
	}
	func pushDealingModel(type: Any.Type) {
		if Thread.AllModelCache[type] == nil {
			let encoder = ModelAttributeEncoder(modelType: type)
			if let type = type as? HappyCodable.Type {
				Thread.attributeEncoder = encoder
				try? type.init().encode(to: encoder)
				Thread.attributeEncoder = nil
				encoder.cachingModel.defaltDecodeJSON = type.defaultModelEncodeJSON()
			}
			Thread.AllModelCache[type] = encoder.cachingModel
		}
		self.dealingModels.append(Thread.AllModelCache[type]!)
	}
	func popDealingModel() {
		self.dealingModels.removeLast()
	}

	// patch end
	
	// MARK: - Decoder Methods
	public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
		guard !(self.storage.topContainer is NSNull) else {
			throw DecodingError.valueNotFound(KeyedDecodingContainer<Key>.self,
											  DecodingError.Context(codingPath: self.codingPath,
																	debugDescription: "Cannot get keyed decoding container -- found null value instead."))
		}
		
		guard let topContainer = self.storage.topContainer as? [String : Any] else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: [String : Any].self, reality: self.storage.topContainer)
		}
		
		let container = _JSONKeyedDecodingContainer<Key>(referencing: self, wrapping: topContainer)
		return KeyedDecodingContainer(container)
	}
	
	public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		guard !(self.storage.topContainer is NSNull) else {
			throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self,
											  DecodingError.Context(codingPath: self.codingPath,
																	debugDescription: "Cannot get unkeyed decoding container -- found null value instead."))
		}
		
		guard let topContainer = self.storage.topContainer as? [Any] else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: [Any].self, reality: self.storage.topContainer)
		}
		
		return _JSONUnkeyedDecodingContainer(referencing: self, wrapping: topContainer)
	}
	
	public func singleValueContainer() throws -> SingleValueDecodingContainer {
		return self
	}
}

// MARK: - Decoding Storage, 修改内容
private struct _JSONDecodingStorage {
	// MARK: Properties
	/// The container stack.
	/// Elements may be any one of the JSON types (NSNull, NSNumber, String, Array, [String : Any]).
	private(set) var containers: [Any] = []
	
	// MARK: - Initialization
	/// Initializes `self` with no containers.
	init() {}
	
	// MARK: - Modifying the Stack
	var count: Int {
		return self.containers.count
	}
	
	var topContainer: Any {
		precondition(!self.containers.isEmpty, "Empty container stack.")
		return self.containers.last!
	}
	
	mutating func push(container: __owned Any) {
		self.containers.append(container)
	}
	
	mutating func popContainer() {
		precondition(!self.containers.isEmpty, "Empty container stack.")
		self.containers.removeLast()
	}
}

// MARK: - 以下内容照搬原生就行
// MARK: Decoding Containers
private struct _JSONKeyedDecodingContainer<K : CodingKey> : KeyedDecodingContainerProtocol {
	typealias Key = K
	
	// MARK: Properties
	/// A reference to the decoder we're reading from.
	private let decoder: __JSONDecoder
	
	/// A reference to the container we're reading from.
	private let container: [String : Any]
	
	/// The path of coding keys taken to get to this point in decoding.
	private(set) public var codingPath: [CodingKey]
	
	// MARK: - Initialization
	/// Initializes `self` by referencing the given decoder and container.
	init(referencing decoder: __JSONDecoder, wrapping container: [String : Any]) {
		self.decoder = decoder
		/* patch begin
		switch decoder.options.keyDecodingStrategy {
		case .useDefaultKeys:
			self.container = container
		case .convertFromSnakeCase:
			// Convert the snake case keys in the container to camel case.
			// If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
			self.container = Dictionary(container.map {
				key, value in (JSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(key), value)
			}, uniquingKeysWith: { (first, _) in first })
		case .custom(let converter):
			self.container = Dictionary(container.map {
				key, value in (converter(decoder.codingPath + [_JSONKey(stringValue: key, intValue: nil)]).stringValue, value)
			}, uniquingKeysWith: { (first, _) in first })
		}
		patch end */
		self.container = container
		self.codingPath = decoder.codingPath
	}
	
	// MARK: - KeyedDecodingContainerProtocol Methods
	public var allKeys: [Key] {
		return self.container.keys.compactMap { Key(stringValue: $0) }
	}
	
	public func contains(_ key: Key) -> Bool {
		// patch begin
		let value = self.container[mainKey: key.stringValue, from: decoder]
		if decoder.dealingModel.decodeAttributes[key.stringValue] != nil, value is NSNull {
			return false
		}
		return value != nil
		// patch end
	}
	
	private func _errorDescription(of key: CodingKey) -> String {
		// patch begin
		return "\(key) (\"\(key.stringValue)\")"
		// patch end
	}
	
	public func decodeNil(forKey key: Key) throws -> Bool {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		return entry is NSNull
	}
	
	public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Bool.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Bool?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Bool
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Int.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Int?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Int
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Int8.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Int8?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Int8
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Int16.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Int16?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Int16
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Int32.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Int32?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Int32
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Int64.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Int64?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Int64
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: UInt.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: UInt?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? UInt
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: UInt8.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: UInt8?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? UInt8
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: UInt16.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: UInt16?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? UInt16
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: UInt32.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: UInt32?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? UInt32
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: UInt64.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: UInt64?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? UInt64
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Float.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Float?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Float
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: Double.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: Double?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? Double
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode(_ type: String.Type, forKey key: Key) throws -> String {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		// patch begin
		var _error: Error?
		do {
			if let value = try self.decoder.unbox(entry, as: String.self) {
				return value
			}
		} catch {
			_error = error
		}
		
        var value: String?
        if decoder.dealingModel.decodeAttributes[key.stringValue] == nil {
            value = decoder.dealingModel.defaltDecodeJSON[key.stringValue] as? String
        }
		if decoder.options.errorsCatcher == nil, value != nil {
			return value!
		} else {
			let error = _error ?? DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
			decoder.options.errorsCatcher?(error)
			throw error
		}
		//path end
	}
	
	public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
		guard let entry = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(_errorDescription(of: key))."))
		}
		
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		guard let value = try self.decoder.unbox(entry, as: type) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Expected \(type) value but found null instead."))
		}
		
		return value
	}
	
	public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		guard let value = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key,
											DecodingError.Context(codingPath: self.codingPath,
																  debugDescription: "Cannot get \(KeyedDecodingContainer<NestedKey>.self) -- no value found for key \(_errorDescription(of: key))"))
		}
		
		guard let dictionary = value as? [String : Any] else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: [String : Any].self, reality: value)
		}
		
		let container = _JSONKeyedDecodingContainer<NestedKey>(referencing: self.decoder, wrapping: dictionary)
		return KeyedDecodingContainer(container)
	}
	
	public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		self.decoder.codingPath.append(key)
		defer { self.decoder.codingPath.removeLast() }
		
		guard let value = self.container[mainKey: key.stringValue, from: decoder] else {
			throw DecodingError.keyNotFound(key,
											DecodingError.Context(codingPath: self.codingPath,
																  debugDescription: "Cannot get UnkeyedDecodingContainer -- no value found for key \(_errorDescription(of: key))"))
		}
		
		guard let array = value as? [Any] else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: [Any].self, reality: value)
		}
		
		return _JSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
	}
	
//	private func _superDecoder(forKey key: __owned CodingKey) throws -> Decoder {
//		self.decoder.codingPath.append(key)
//		defer { self.decoder.codingPath.removeLast() }
//
//		let value: Any = self.container[mainKey: key.stringValue, from: decoder] ?? NSNull()
//		return __JSONDecoder(referencing: value, as: <#Any.Type#>, at: self.decoder.codingPath, options: self.decoder.options)
//	}
	
	public func superDecoder() throws -> Decoder {
		fatalError("not working yet")
//		return try _superDecoder(forKey: _JSONKey.super)
	}
	
	public func superDecoder(forKey key: Key) throws -> Decoder {
		fatalError("not working yet")
//		return try _superDecoder(forKey: key)
	}
}
// MARK: - 以下内容照搬原生就行
private struct _JSONUnkeyedDecodingContainer : UnkeyedDecodingContainer {
	// MARK: Properties
	/// A reference to the decoder we're reading from.
	private let decoder: __JSONDecoder
	
	/// A reference to the container we're reading from.
	private let container: [Any]
	
	/// The path of coding keys taken to get to this point in decoding.
	private(set) public var codingPath: [CodingKey]
	
	/// The index of the element we're about to decode.
	private(set) public var currentIndex: Int
	
	// MARK: - Initialization
	/// Initializes `self` by referencing the given decoder and container.
	init(referencing decoder: __JSONDecoder, wrapping container: [Any]) {
		self.decoder = decoder
		self.container = container
		self.codingPath = decoder.codingPath
		self.currentIndex = 0
	}
	
	// MARK: - UnkeyedDecodingContainer Methods
	public var count: Int? {
		return self.container.count
	}
	
	public var isAtEnd: Bool {
		return self.currentIndex >= self.count!
	}
	
	public mutating func decodeNil() throws -> Bool {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(Any?.self, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		if self.container[self.currentIndex] is NSNull {
			self.currentIndex += 1
			return true
		} else {
			return false
		}
	}
	
	public mutating func decode(_ type: Bool.Type) throws -> Bool {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Bool.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: Int.Type) throws -> Int {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: Int8.Type) throws -> Int8 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int8.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: Int16.Type) throws -> Int16 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int16.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: Int32.Type) throws -> Int32 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int32.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: Int64.Type) throws -> Int64 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int64.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: UInt.Type) throws -> UInt {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt8.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt16.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt32.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt64.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: Float.Type) throws -> Float {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Float.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: Double.Type) throws -> Double {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Double.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode(_ type: String.Type) throws -> String {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: String.self) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func decode<T : Decodable>(_ type: T.Type) throws -> T {
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
		}
		
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: type) else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))
		}
		
		self.currentIndex += 1
		return decoded
	}
	
	public mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self,
											  DecodingError.Context(codingPath: self.codingPath,
																	debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."))
		}
		
		let value = self.container[self.currentIndex]
		guard !(value is NSNull) else {
			throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self,
											  DecodingError.Context(codingPath: self.codingPath,
																	debugDescription: "Cannot get keyed decoding container -- found null value instead."))
		}
		
		guard let dictionary = value as? [String : Any] else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: [String : Any].self, reality: value)
		}
		
		self.currentIndex += 1
		let container = _JSONKeyedDecodingContainer<NestedKey>(referencing: self.decoder, wrapping: dictionary)
		return KeyedDecodingContainer(container)
	}
	
	public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
		defer { self.decoder.codingPath.removeLast() }
		
		guard !self.isAtEnd else {
			throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self,
											  DecodingError.Context(codingPath: self.codingPath,
																	debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."))
		}
		
		let value = self.container[self.currentIndex]
		guard !(value is NSNull) else {
			throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self,
											  DecodingError.Context(codingPath: self.codingPath,
																	debugDescription: "Cannot get keyed decoding container -- found null value instead."))
		}
		
		guard let array = value as? [Any] else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: [Any].self, reality: value)
		}
		
		self.currentIndex += 1
		return _JSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
	}
	
	public mutating func superDecoder() throws -> Decoder {
		fatalError("not working yet")
//		self.decoder.codingPath.append(_JSONKey(index: self.currentIndex))
//		defer { self.decoder.codingPath.removeLast() }
//
//		guard !self.isAtEnd else {
//			throw DecodingError.valueNotFound(Decoder.self,
//											  DecodingError.Context(codingPath: self.codingPath,
//																	debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."))
//		}
//
//		let value = self.container[self.currentIndex]
//		self.currentIndex += 1
//		return __JSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
	}
}

// MARK: - 以下内容照搬原生就行
extension __JSONDecoder : SingleValueDecodingContainer {
	// MARK: SingleValueDecodingContainer Methods
	private func expectNonNull<T>(_ type: T.Type) throws {
		guard !self.decodeNil() else {
			throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected \(type) but found null value instead."))
		}
	}
	
	public func decodeNil() -> Bool {
		return self.storage.topContainer is NSNull
	}
	
	public func decode(_ type: Bool.Type) throws -> Bool {
		try expectNonNull(Bool.self)
		return try self.unbox(self.storage.topContainer, as: Bool.self)!
	}
	
	public func decode(_ type: Int.Type) throws -> Int {
		try expectNonNull(Int.self)
		return try self.unbox(self.storage.topContainer, as: Int.self)!
	}
	
	public func decode(_ type: Int8.Type) throws -> Int8 {
		try expectNonNull(Int8.self)
		return try self.unbox(self.storage.topContainer, as: Int8.self)!
	}
	
	public func decode(_ type: Int16.Type) throws -> Int16 {
		try expectNonNull(Int16.self)
		return try self.unbox(self.storage.topContainer, as: Int16.self)!
	}
	
	public func decode(_ type: Int32.Type) throws -> Int32 {
		try expectNonNull(Int32.self)
		return try self.unbox(self.storage.topContainer, as: Int32.self)!
	}
	
	public func decode(_ type: Int64.Type) throws -> Int64 {
		try expectNonNull(Int64.self)
		return try self.unbox(self.storage.topContainer, as: Int64.self)!
	}
	
	public func decode(_ type: UInt.Type) throws -> UInt {
		try expectNonNull(UInt.self)
		return try self.unbox(self.storage.topContainer, as: UInt.self)!
	}
	
	public func decode(_ type: UInt8.Type) throws -> UInt8 {
		try expectNonNull(UInt8.self)
		return try self.unbox(self.storage.topContainer, as: UInt8.self)!
	}
	
	public func decode(_ type: UInt16.Type) throws -> UInt16 {
		try expectNonNull(UInt16.self)
		return try self.unbox(self.storage.topContainer, as: UInt16.self)!
	}
	
	public func decode(_ type: UInt32.Type) throws -> UInt32 {
		try expectNonNull(UInt32.self)
		return try self.unbox(self.storage.topContainer, as: UInt32.self)!
	}
	
	public func decode(_ type: UInt64.Type) throws -> UInt64 {
		try expectNonNull(UInt64.self)
		return try self.unbox(self.storage.topContainer, as: UInt64.self)!
	}
	
	public func decode(_ type: Float.Type) throws -> Float {
		try expectNonNull(Float.self)
		return try self.unbox(self.storage.topContainer, as: Float.self)!
	}
	
	public func decode(_ type: Double.Type) throws -> Double {
		try expectNonNull(Double.self)
		return try self.unbox(self.storage.topContainer, as: Double.self)!
	}
	
	public func decode(_ type: String.Type) throws -> String {
		try expectNonNull(String.self)
		return try self.unbox(self.storage.topContainer, as: String.self)!
	}
	
	public func decode<T : Decodable>(_ type: T.Type) throws -> T {
		try expectNonNull(type)
		return try self.unbox(self.storage.topContainer, as: type)!
	}
}

// MARK: - Concrete Value Representations, 以下部分需要修改
func boundsCheck<T>(value: Int64, errorPath: [CodingKey]) throws -> T where T: FixedWidthInteger {
	guard value <= T.max, value >= T.min else {
		throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: errorPath, debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
	}
	return T(value)
}
func boundsCheck<T>(value: UInt64, errorPath: [CodingKey]) throws -> T where T: FixedWidthInteger {
	guard value <= T.max, value >= T.min else {
		throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: errorPath, debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
	}
	return T(value)
}
private extension __JSONDecoder {
	/// Returns the given value unboxed from a container.
	func unbox(_ value: Any, as type: Bool.Type) throws -> Bool? {
		guard !(value is NSNull) else { return nil }
		
		if let number = value as? NSNumber {
			// TODO: Add a flag to coerce non-boolean numbers into Bools?
			if number === kCFBooleanTrue as NSNumber {
				return true
			} else if number === kCFBooleanFalse as NSNumber {
				return false
			}
			
			/* FIXME: If swift-corelibs-foundation doesn't change to use NSNumber, this code path will need to be included and tested:
			} else if let bool = value as? Bool {
			return bool
			*/
			
			// patch begin
			if number.intValue == 0 {
				return false
			} else {
				return true
			}
		}
		if let value = value as? String {
			if let result = Bool(value) {
				return result
			} else if let result = Int(value) {
				return result != 0
			}
		}
		// patch end
		
		throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
	}
	
	func unbox(_ value: Any, as type: Int.Type) throws -> Int? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = Int64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let int = number.intValue
		guard NSNumber(value: int) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return int
	}
	
	func unbox(_ value: Any, as type: Int8.Type) throws -> Int8? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = Int64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let int8 = number.int8Value
		guard NSNumber(value: int8) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return int8
	}
	
	func unbox(_ value: Any, as type: Int16.Type) throws -> Int16? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = Int64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let int16 = number.int16Value
		guard NSNumber(value: int16) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return int16
	}
	
	func unbox(_ value: Any, as type: Int32.Type) throws -> Int32? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = Int64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let int32 = number.int32Value
		guard NSNumber(value: int32) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return int32
	}
	
	func unbox(_ value: Any, as type: Int64.Type) throws -> Int64? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = Int64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let int64 = number.int64Value
		guard NSNumber(value: int64) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return int64
	}
	
	func unbox(_ value: Any, as type: UInt.Type) throws -> UInt? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = UInt64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let uint = number.uintValue
		guard NSNumber(value: uint) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return uint
	}
	
	func unbox(_ value: Any, as type: UInt8.Type) throws -> UInt8? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = UInt64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let uint8 = number.uint8Value
		guard NSNumber(value: uint8) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return uint8
	}
	
	func unbox(_ value: Any, as type: UInt16.Type) throws -> UInt16? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = UInt64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let uint16 = number.uint16Value
		guard NSNumber(value: uint16) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return uint16
	}
	
	func unbox(_ value: Any, as type: UInt32.Type) throws -> UInt32? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = UInt64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let uint32 = number.uint32Value
		guard NSNumber(value: uint32) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return uint32
	}
	
	func unbox(_ value: Any, as type: UInt64.Type) throws -> UInt64? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? String, let int64 = UInt64(value) {
			return try boundsCheck(value: int64, errorPath: codingPath)
		}
		// patch end
		
		guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		let uint64 = number.uint64Value
		guard NSNumber(value: uint64) == number else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
		}
		
		return uint64
	}
	
	func unbox(_ value: Any, as type: Float.Type) throws -> Float? {
		guard !(value is NSNull) else { return nil }
		
		if let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse {
			// We are willing to return a Float by losing precision:
			// * If the original value was integral,
			//   * and the integral value was > Float.greatestFiniteMagnitude, we will fail
			//   * and the integral value was <= Float.greatestFiniteMagnitude, we are willing to lose precision past 2^24
			// * If it was a Float, you will get back the precise value
			// * If it was a Double or Decimal, you will get back the nearest approximation if it will fit
			let double = number.doubleValue
			guard abs(double) <= Double(Float.greatestFiniteMagnitude) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number \(number) does not fit in \(type)."))
			}
			
			return Float(double)
			
			/* FIXME: If swift-corelibs-foundation doesn't change to use NSNumber, this code path will need to be included and tested:
			} else if let double = value as? Double {
			if abs(double) <= Double(Float.max) {
			return Float(double)
			}
			overflow = true
			} else if let int = value as? Int {
			if let float = Float(exactly: int) {
			return float
			}
			overflow = true
			*/
			
		}/* patch begin else if let string = value as? String,
				  case .convertFromString(let posInfString, let negInfString, let nanString) = self.options.nonConformingFloatDecodingStrategy {
			if string == posInfString {
				return Float.infinity
			} else if string == negInfString {
				return -Float.infinity
			} else if string == nanString {
				return Float.nan
			}
		}patch end */
		
		// patch begin
		if let string = value as? String, let result = Float(string) {
			return result
		}
		// patch end
		
		throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
	}
	
	func unbox(_ value: Any, as type: Double.Type) throws -> Double? {
		guard !(value is NSNull) else { return nil }
		
		if let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse {
			// We are always willing to return the number as a Double:
			// * If the original value was integral, it is guaranteed to fit in a Double; we are willing to lose precision past 2^53 if you encoded a UInt64 but requested a Double
			// * If it was a Float or Double, you will get back the precise value
			// * If it was Decimal, you will get back the nearest approximation
			return number.doubleValue
			
			/* FIXME: If swift-corelibs-foundation doesn't change to use NSNumber, this code path will need to be included and tested:
			} else if let double = value as? Double {
			return double
			} else if let int = value as? Int {
			if let double = Double(exactly: int) {
			return double
			}
			overflow = true
			*/
			
		}/* patch begin else if let string = value as? String,
				  case .convertFromString(let posInfString, let negInfString, let nanString) = self.options.nonConformingFloatDecodingStrategy {
			if string == posInfString {
				return Double.infinity
			} else if string == negInfString {
				return -Double.infinity
			} else if string == nanString {
				return Double.nan
			}
		}patch end */
		
		// patch begin
		if let string = value as? String, let result = Double(string) {
			return result
		}
		// patch end
		
		throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
	}
	
	func unbox(_ value: Any, as type: String.Type) throws -> String? {
		guard !(value is NSNull) else { return nil }
		
		// patch begin
		if let value = value as? NSNumber {
			if CFGetTypeID(value) == CFBooleanGetTypeID() {
				return "\(value.boolValue)"
			} else {
				return value.stringValue
			}
		}
		// patch end
		
		guard let string = value as? String else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		
		return string
	}
	/* patch begin
	func unbox(_ value: Any, as type: Date.Type) throws -> Date? {
		guard !(value is NSNull) else { return nil }
		
		switch self.options.dateDecodingStrategy {
		case .deferredToDate:
			self.storage.push(container: (Date.self, value))
			defer { self.storage.popContainer() }
			return try Date(from: self)
			
		case .secondsSince1970:
			let double = try self.unbox(value, as: Double.self)!
			return Date(timeIntervalSince1970: double)
			
		case .millisecondsSince1970:
			let double = try self.unbox(value, as: Double.self)!
			return Date(timeIntervalSince1970: double / 1000.0)
			
		case .iso8601:
			if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
				let string = try self.unbox(value, as: String.self)!
				guard let date = _iso8601Formatter.date(from: string) else {
					throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
				}
				
				return date
			} else {
				fatalError("ISO8601DateFormatter is unavailable on this platform.")
			}
			
		case .formatted(let formatter):
			let string = try self.unbox(value, as: String.self)!
			guard let date = formatter.date(from: string) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Date string does not match format expected by formatter."))
			}
			
			return date
			
		case .custom(let closure):
			self.storage.push(container: (Date.self, value))
			defer { self.storage.popContainer() }
			return try closure(self)
		}
	}
	
	func unbox(_ value: Any, as type: Data.Type) throws -> Data? {
		guard !(value is NSNull) else { return nil }
		
		switch self.options.dataStrategy {
		case .deferredToData:
			self.storage.push(container: (Data.self, value))
			defer { self.storage.popContainer() }
			return try Data(from: self)
			
		case .base64:
			guard let string = value as? String else {
				throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
			}
			
			guard let data = Data(base64Encoded: string) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Encountered Data is not valid Base64."))
			}
			
			return data
			
		case .custom(let closure):
			self.storage.push(container: (Data.self, value))
			defer { self.storage.popContainer() }
			return try closure(self)
		}
	}
	patch end */
	
	func unbox(_ value: Any, as type: Decimal.Type) throws -> Decimal? {
		guard !(value is NSNull) else { return nil }
		
		// Attempt to bridge from NSDecimalNumber.
		if let decimal = value as? Decimal {
			return decimal
		} else {
			let doubleValue = try self.unbox(value, as: Double.self)!
			return Decimal(doubleValue)
		}
	}
	
	func unbox<T>(_ value: Any, as type: _JSONStringDictionaryDecodableMarker.Type) throws -> T? {
		guard !(value is NSNull) else { return nil }
		
		var result = [String : Any]()
		guard let dict = value as? NSDictionary else {
			throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
		}
		let elementType = type.elementType
		for (key, value) in dict {
			let key = key as! String
			self.codingPath.append(_JSONKey(stringValue: key, intValue: nil))
			defer { self.codingPath.removeLast() }
			
			result[key] = try unbox_(value, as: elementType)
		}
		
		return result as? T
	}
	
	func unbox<T : Decodable>(_ value: Any? = nil, as type: T.Type) throws -> T? {
		return try unbox_(value ?? storage.topContainer, as: type) as? T
	}
	
	func unbox_(_ value: Any, as type: Decodable.Type) throws -> Any? {
		/*patch begin
		if type == Date.self || type == NSDate.self {
			return try self.unbox(value, as: Date.self)
		} else if type == Data.self || type == NSData.self {
			return try self.unbox(value, as: Data.self)
		} else patch end*/ if type == URL.self || type == NSURL.self {
			guard let urlString = try self.unbox(value, as: String.self) else {
				return nil
			}
			
			guard let url = URL(string: urlString) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath,
																		debugDescription: "Invalid URL string."))
			}
			return url
		} else if type == Decimal.self || type == NSDecimalNumber.self {
			return try self.unbox(value, as: Decimal.self)
		} else if let stringKeyedDictType = type as? _JSONStringDictionaryDecodableMarker.Type {
			return try self.unbox(value, as: stringKeyedDictType)
		} else {
			var value = value
			if value is NSNull, let key = codingPath.last, let defaultValue = dealingModel.defaltDecodeJSON[key.stringValue] {
				value = defaultValue
			}
			self.storage.push(container: value)
			pushDealingModel(type: type)
			defer { self.storage.popContainer(); popDealingModel() }
			
			return try type.init(from: self)
		}
	}
}

//===----------------------------------------------------------------------===//
// Shared Key Types
//===----------------------------------------------------------------------===//
struct _JSONKey : CodingKey {
	public var stringValue: String
	public var intValue: Int?
	
	public init?(stringValue: String) {
		self.stringValue = stringValue
		self.intValue = nil
	}
	
	public init?(intValue: Int) {
		self.stringValue = "\(intValue)"
		self.intValue = intValue
	}
	
	public init(stringValue: String, intValue: Int?) {
		self.stringValue = stringValue
		self.intValue = intValue
	}
	
	init(index: Int) {
		self.stringValue = "Index \(index)"
		self.intValue = index
	}
	
	static let `super` = _JSONKey(stringValue: "super")!
}

//===----------------------------------------------------------------------===//
// Shared ISO8601 Date Formatter
//===----------------------------------------------------------------------===//
// NOTE: This value is implicitly lazy and _must_ be lazy. We're compiled against the latest SDK (w/ ISO8601DateFormatter), but linked against whichever Foundation the user has. ISO8601DateFormatter might not exist, so we better not hit this code path on an older OS.
@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
var _iso8601Formatter: ISO8601DateFormatter = {
	let formatter = ISO8601DateFormatter()
	formatter.formatOptions = .withInternetDateTime
	return formatter
}()

extension EncodingError {
	/// Returns a `.invalidValue` error describing the given invalid floating-point value.
	///
	///
	/// - parameter value: The value that was invalid to encode.
	/// - parameter path: The path of `CodingKey`s taken to encode this value.
	/// - returns: An `EncodingError` with the appropriate path and debug description.
	static func _invalidFloatingPointValue<T : FloatingPoint>(_ value: T, at codingPath: [CodingKey]) -> EncodingError {
		let valueDescription: String
		if value == T.infinity {
			valueDescription = "\(T.self).infinity"
		} else if value == -T.infinity {
			valueDescription = "-\(T.self).infinity"
		} else {
			valueDescription = "\(T.self).nan"
		}
		
		let debugDescription = "Unable to encode \(valueDescription) directly in JSON. Use JSONEncoder.NonConformingFloatEncodingStrategy.convertToString to specify how the value should be encoded."
		return .invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: debugDescription))
	}
}
