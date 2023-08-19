//
//  KeyedDecodingContainer.swift
//  HappyCodable
//
//

import Foundation

// MARK: - Interfaces
extension KeyedDecodingContainer<String> {
	// MARK: - Decodable
	@inlinable
	@inline(__always)
	@_disfavoredOverload
	public func decode<T>(key: String, alterKeys: (() -> [String])? = nil) throws -> T where T: Decodable {
		try decodeDecodable(mainKey: key, alterKeys: alterKeys, optional: false)
	}
	@inlinable
	@inline(__always)
	public func decode<T>(key: String, alterKeys: (() -> [String])? = nil) throws -> T? where T: Decodable {
		try decodeDecodable(mainKey: key, alterKeys: alterKeys, optional: true) as T
	}

	// MARK: - Bool
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Bool? {
		try decodeBool(mainKey: key, alterKeys: alterKeys, optional: true)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Bool {
		try decodeBool(mainKey: key, alterKeys: alterKeys, optional: false)
	}

	// MARK: - String
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> String? {
		try decodeString(mainKey: key, alterKeys: alterKeys, optional: true)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> String {
		try decodeString(mainKey: key, alterKeys: alterKeys, optional: false)
	}

	// MARK: - Data
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Data? {
		try decodeData(mainKey: key, alterKeys: alterKeys, optional: true)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Data {
		try decodeData(mainKey: key, alterKeys: alterKeys, optional: false)
	}

	// MARK: - Double
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Double? {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Double.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Double {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Double.self)
	}

	// MARK: - Float
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Float? {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Float.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Float {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Float.self)
	}

	// MARK: - Int
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int.self)
	}

	// MARK: - Int8
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int8? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int8.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int8 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int8.self)
	}

	// MARK: - Int16
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int16? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int16.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int16 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int16.self)
	}

	// MARK: - Int32
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int32? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int32.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int32 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int32.self)
	}

	// MARK: - Int64
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int64? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int64.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int64 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int64.self)
	}

	// MARK: - UInt
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt.self)
	}

	// MARK: - UInt8
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt8? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt8.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt8 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt8.self)
	}

	// MARK: - UInt16
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt16? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt16.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt16 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt16.self)
	}

	// MARK: - UInt32
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt32? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt32.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt32 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt32.self)
	}

	// MARK: - UInt64
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt64? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt64.self)
	}
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt64 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt64.self)
	}
}

@usableFromInline var _iso8601Formatter: ISO8601DateFormatter = {
	let formatter = ISO8601DateFormatter()
	formatter.formatOptions = .withInternetDateTime
	return formatter
}()

// MARK: - Strategy implementation
extension KeyedDecodingContainer<String> {
	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil, strategy: Foundation.JSONDecoder.DataDecodingStrategy) throws -> Data {
		switch strategy {
		case .deferredToData:
			return try decode(key: key, alterKeys: alterKeys)
		case .base64:
			let string: String = try decode(key: key, alterKeys: alterKeys)
			guard let data = Data(base64Encoded: string) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Encountered Data is not valid Base64."))
			}
			return data
		case .custom(let closure):
			return try closure(superDecoder(forKey: key))
		@unknown default:
			fatalError("not implemented")
		}
	}

	@inlinable
	@inline(__always)
	public func decode(key: String, alterKeys: (() -> [String])? = nil, strategy: Foundation.JSONDecoder.DateDecodingStrategy) throws -> Date {
		switch strategy {
		case .deferredToDate:
			return Date(timeIntervalSinceReferenceDate: try decode(key: key, alterKeys: alterKeys))
		case .secondsSince1970:
			return Date(timeIntervalSince1970: try decode(key: key, alterKeys: alterKeys))
		case .millisecondsSince1970:
			return Date(timeIntervalSince1970: try decode(key: key, alterKeys: alterKeys) / 1000.0)
		case .iso8601:
			let string = try decode(Swift.String.self, forKey: key)
			guard let date = _iso8601Formatter.date(from: string) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Expected date string to be ISO8601-formatted."))
			}

			return date
		case .formatted(let formatter):
			let string = try decode(Swift.String.self, forKey: key)
			guard let date = formatter.date(from: string) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Date string does not match format expected by formatter."))
			}

			return date
		case .custom(let closure):
			return try closure(superDecoder(forKey: key))
		@unknown default:
			fatalError("not implemented")
		}
	}

	// copy from https://github.com/apple/swift-corelibs-foundation/blob/0ac1a34ab76f6db3196a279c2626a0e4554ff592/Sources/Foundation/JSONDecoder.swift#L413
	@inlinable
	@inline(__always)
	public func decode<T>(key: String, alterKeys: (() -> [String])? = nil, strategy: Foundation.JSONDecoder.NonConformingFloatDecodingStrategy) throws -> T where T: BinaryFloatingPoint & LosslessStringConvertible {

		if let number: Double = try? decode(key: key, alterKeys: alterKeys) {
			let floatingPoint = T(number)
			guard floatingPoint.isFinite else {
				throw DecodingError.dataCorrupted(
					.init(
						codingPath: codingPath + [key],
						debugDescription: "Parsed JSON number <\(number)> does not fit in \(Float.self)."
					)
				)
			}

			return floatingPoint
		}

		if let string: String = try? decode(key: key, alterKeys: alterKeys),
		   case .convertFromString(let posInfString, let negInfString, let nanString) = strategy {
			if string == posInfString {
				return T.infinity
			} else if string == negInfString {
				return -T.infinity
			} else if string == nanString {
				return T.nan
			}
		}

		throw DecodingError.typeMismatch(T.self, .init(
			codingPath: codingPath + [key],
			debugDescription: "Expected to decode \(T.self) but found Unknown type instead."
		))
	}

	@inlinable
	@inline(__always)
	public func decode<T>(key: String, alterKeys: (() -> [String])? = nil, strategy: Void) throws -> [T] where T: Decodable {
		let elements: [T?] = try decode(key: key, alterKeys: alterKeys)
		return elements.compactMap { $0 }
	}
}

// MARK: - Generic implementation
extension KeyedDecodingContainer<String> {
	// MARK: - Sub Interface
	// MARK: - Decodable
	@inlinable
	@inline(__always)
	func decodeDecodable<T>(mainKey: String, alterKeys: (() -> [String])?, optional: Bool) throws -> T where T: Decodable {
		func _decode(key: String) throws -> T {
			if optional {
				if let value = try decodeIfPresent(T.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected \(T.self) value but found nothing."))
				}
			} else {
				return try decode(T.self, forKey: key)
			}
		}
		do {
			return try _decode(key: mainKey)
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys where contains(key) {
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}

			throw error
		}
	}
	// MARK: - Bool
	@inlinable
	@inline(__always)
	func decodeBool(mainKey: String, alterKeys: (() -> [String])?, optional: Bool) throws -> Bool {
		func _decode(key: String) throws -> Bool {
			do {
				if optional {
					if let value = try decodeIfPresent(Bool.self, forKey: key) {
						return value
					} else {
						throw DecodingError.valueNotFound(Bool.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Bool value but found nothing."))
					}
				} else {
					return try decode(Bool.self, forKey: key)
				}
			} catch {
				if case DecodingError.typeMismatch = error {
					if let value = try? decodeIfPresent(Int.self, forKey: key) {
						return value == 1
					} else if let value = try? decodeIfPresent(Swift.String.self, forKey: key) {
						if let result = Bool(value) {
							return result
						} else if let result = Int(value) {
							return result == 1
						}
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: mainKey)
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys where contains(key) {
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}

			throw error
		}
	}
	// MARK: - String
	@inlinable
	@inline(__always)
	func decodeString(mainKey: String, alterKeys: (() -> [String])?, optional: Bool) throws -> String {
		func _decode(key: String) throws -> String {
			do {
				if optional {
					if let value = try decodeIfPresent(Swift.String.self, forKey: key) {
						return value
					} else {
						throw DecodingError.valueNotFound(Swift.String.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected String value but found nothing."))
					}
				} else {
					return try decode(Swift.String.self, forKey: key)
				}
			} catch {
				if case DecodingError.typeMismatch = error {
					if let value = try? decodeIfPresent(Bool.self, forKey: key) {
						return String(value)
					}
					if let value = try? decodeIfPresent(Int64.self, forKey: key) {
						return String(value)
					}
					if let value = try? decodeIfPresent(UInt64.self, forKey: key) {
						return String(value)
					}
					if let value = try? decodeIfPresent(Double.self, forKey: key) {
						return String(value)
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: mainKey)
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys where contains(key) {
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}

			throw error
		}
	}
	// MARK: - Data
	@inlinable
	@inline(__always)
	func decodeData(mainKey: String, alterKeys: (() -> [String])?, optional: Bool) throws -> Data {
		func _decode(key: String) throws -> Data {
			do {
				if optional {
					if let value = try decodeIfPresent(Data.self, forKey: key) {
						return value
					} else {
						throw DecodingError.valueNotFound(Swift.String.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected String value but found nothing."))
					}
				} else {
					return try decode(Data.self, forKey: key)
				}
			} catch {
				throw error
			}
		}
		do {
			return try _decode(key: mainKey)
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys where contains(key) {
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}

			throw error
		}
	}
	// MARK: - Double
	@inlinable
	@inline(__always)
	func decodeDouble<T>(mainKey: String, alterKeys: (() -> [String])?, optional: Bool, targetType: T.Type) throws -> T where T: BinaryFloatingPoint {
		func convert(_ value: Double) -> T {
			value as? T ?? T(value)
		}
		func _decode(key: String) throws -> T {
			do {
				if optional {
					if let value = try decodeIfPresent(Double.self, forKey: key) {
						return convert(value)
					} else {
						throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected \(T.self) value but found nothing."))
					}
				} else {
					return convert(try decode(Double.self, forKey: key))
				}
			} catch {
				if case DecodingError.typeMismatch = error {
					if let value = try? decodeIfPresent(Swift.String.self, forKey: key), let result = Double(value) {
						return convert(result)
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: mainKey)
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys where contains(key) {
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}

			throw error
		}
	}

	// MARK: - Int
	@inlinable
	@inline(__always)
	func decodeInt<T>(mainKey: String, alterKeys: (() -> [String])?, optional: Bool, targetType: T.Type) throws -> T where T: FixedWidthInteger {
		func boundsCheck(value: Int64, for key: String) throws -> T {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return T(value)
		}
		func _decode(key: String) throws -> T {
			do {
				if optional {
					if let value = try decodeIfPresent(Int64.self, forKey: key) {
						return try boundsCheck(value: value, for: key)
					} else {
						throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected \(T.self) value but found nothing."))
					}
				} else {
					return try boundsCheck(value: try decode(Int64.self, forKey: key), for: key)
				}
			} catch {
				if case DecodingError.typeMismatch = error {
					if let value = try? decodeIfPresent(Swift.String.self, forKey: key), let int64 = Int64(value), let result = try? boundsCheck(value: int64, for: key) {
						return result
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: mainKey)
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys where contains(key) {
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}

			throw error
		}
	}

	// MARK: - UInt
	@inlinable
	@inline(__always)
	func decodeUInt<T>(mainKey: String, alterKeys: (() -> [String])?, optional: Bool, targetType: T.Type) throws -> T where T: FixedWidthInteger {
		func boundsCheck(value: UInt64, for key: String) throws -> T {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return T(value)
		}
		func _decode(key: String) throws -> T {
			do {
				if optional {
					if let value = try decodeIfPresent(UInt64.self, forKey: key) {
						return try boundsCheck(value: value, for: key)
					} else {
						throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected \(T.self) value but found nothing."))
					}
				} else {
					return try boundsCheck(value: try decode(UInt64.self, forKey: key), for: key)
				}
			} catch {
				if case DecodingError.typeMismatch = error {
					if let value = try? decodeIfPresent(Swift.String.self, forKey: key), let uint64 = UInt64(value), let result = try? boundsCheck(value: uint64, for: key) {
						return result
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: mainKey)
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys where contains(key) {
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}

			throw error
		}
	}
}
