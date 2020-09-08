//
//  KeyedDecodingContainer.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation

// MARK: - Interfaces
extension KeyedDecodingContainer where Key == StringCodingKey {
	// MARK: - Decodable
	@inlinable
	@_disfavoredOverload
	public func decode<T>(key: String, alterKeys: (() -> [String])? = nil) throws -> T where T: Decodable {
		try decodeDecodable(mainKey: key, alterKeys: alterKeys, optional: false)
	}
	@inlinable
	public func decode<T>(key: String, alterKeys: (() -> [String])? = nil) throws -> T? where T: Decodable {
		try decodeDecodable(mainKey: key, alterKeys: alterKeys, optional: true) as T
	}
	
	// MARK: - Bool
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Bool? {
		try decodeBool(mainKey: key, alterKeys: alterKeys, optional: true)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Bool {
		try decodeBool(mainKey: key, alterKeys: alterKeys, optional: false)
	}
	
	// MARK: - String
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> String? {
		try decodeString(mainKey: key, alterKeys: alterKeys, optional: true)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> String {
		try decodeString(mainKey: key, alterKeys: alterKeys, optional: false)
	}
	
	// MARK: - Double
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Double? {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Double.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Double {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Double.self)
	}
	
	// MARK: - Float
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Float? {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Float.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Float {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Float.self)
	}
	
	// MARK: - Int
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int.self)
	}
	
	// MARK: - Int8
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int8? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int8.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int8 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int8.self)
	}
	
	// MARK: - Int16
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int16? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int16.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int16 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int16.self)
	}
	
	// MARK: - Int32
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int32? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int32.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int32 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int32.self)
	}
	
	// MARK: - Int64
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int64? {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int64.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> Int64 {
		try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int64.self)
	}
	
	// MARK: - UInt
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt.self)
	}
	
	// MARK: - UInt8
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt8? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt8.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt8 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt8.self)
	}
	
	// MARK: - UInt16
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt16? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt16.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt16 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt16.self)
	}
	
	// MARK: - UInt32
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt32? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt32.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt32 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt32.self)
	}
	
	// MARK: - UInt64
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt64? {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt64.self)
	}
	@inlinable
	public func decode(key: String, alterKeys: (() -> [String])? = nil) throws -> UInt64 {
		try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt64.self)
	}
}

// MARK: - Generic implementation
extension KeyedDecodingContainer where Key == StringCodingKey {
	// MARK: - Sub Interface
	// MARK: - Decodable
	@usableFromInline
	func decodeDecodable<T>(mainKey: String, alterKeys: (() -> [String])? , optional: Bool) throws -> T where T: Decodable {
		func _decode(key: StringCodingKey) throws -> T {
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
			return try _decode(key: StringCodingKey(mainKey))
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys {
					let key = StringCodingKey(key)
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}
			
			throw error
		}
	}
	// MARK: - Bool
	@usableFromInline
	func decodeBool(mainKey: String, alterKeys: (() -> [String])? , optional: Bool) throws -> Bool {
		func _decode(key: StringCodingKey) throws -> Bool {
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
					} else if let value = try? decodeIfPresent(String.self, forKey: key) {
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
			return try _decode(key: StringCodingKey(mainKey))
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys {
					let key = StringCodingKey(key)
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}
			
			throw error
		}
	}
	// MARK: - String
	@usableFromInline
	func decodeString(mainKey: String, alterKeys: (() -> [String])? , optional: Bool) throws -> String {
		func _decode(key: StringCodingKey) throws -> String {
			do {
				if optional {
					if let value = try decodeIfPresent(String.self, forKey: key) {
						return value
					} else {
						throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected String value but found nothing."))
					}
				} else {
					return try decode(String.self, forKey: key)
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
			return try _decode(key: StringCodingKey(mainKey))
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys {
					let key = StringCodingKey(key)
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}
			
			throw error
		}
	}
	// MARK: - Double
	@usableFromInline
	func decodeDouble<T>(mainKey: String, alterKeys: (() -> [String])? , optional: Bool, targetType: T.Type) throws -> T where T: BinaryFloatingPoint {
		func convert(_ value: Double) -> T {
			value as? T ?? T(value)
		}
		func _decode(key: StringCodingKey) throws -> T {
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
					if let value = try? decodeIfPresent(String.self, forKey: key), let result = Double(value) {
						return convert(result)
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: StringCodingKey(mainKey))
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys {
					let key = StringCodingKey(key)
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}
			
			throw error
		}
	}
	
	// MARK: - Int
	@usableFromInline
	func decodeInt<T>(mainKey: String, alterKeys: (() -> [String])? , optional: Bool, targetType: T.Type) throws -> T where T: FixedWidthInteger {
		func boundsCheck(value: Int64, for key: StringCodingKey) throws -> T {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return T(value)
		}
		func _decode(key: StringCodingKey) throws -> T {
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
					if let value = try? decodeIfPresent(String.self, forKey: key), let int64 = Int64(value), let result = try? boundsCheck(value: int64, for: key) {
						return result
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: StringCodingKey(mainKey))
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys {
					let key = StringCodingKey(key)
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}
			
			throw error
		}
	}
	
	// MARK: - UInt
	@usableFromInline
	func decodeUInt<T>(mainKey: String, alterKeys: (() -> [String])? , optional: Bool, targetType: T.Type) throws -> T where T: FixedWidthInteger {
		func boundsCheck(value: UInt64, for key: StringCodingKey) throws -> T {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return T(value)
		}
		func _decode(key: StringCodingKey) throws -> T {
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
					if let value = try? decodeIfPresent(String.self, forKey: key), let uint64 = UInt64(value), let result = try? boundsCheck(value: uint64, for: key) {
						return result
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: StringCodingKey(mainKey))
		} catch {
			if let alterKeys = alterKeys?() {
				for key in alterKeys {
					let key = StringCodingKey(key)
					if let value = try? _decode(key: key) {
						return value
					}
				}
			}
			
			throw error
		}
	}
}
