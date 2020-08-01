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
	public func decode<T>(default value: T?, key: String, alterKeys: @autoclosure () -> [String]) throws -> T where T: Decodable {
		try decodeDecodable(mainKey: key, alterKeys: alterKeys, optional: false)
	}
	@inlinable
	public func decode<T>(default value: T?, key: String, alterKeys: @autoclosure () -> [String]) throws -> T? where T: Decodable {
		try decodeDecodable(mainKey: key, alterKeys: alterKeys, optional: true) as T
	}
	
	// MARK: - Bool
	@inlinable
	public func decode(default value: Bool?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Bool? {
		try decodeBool(mainKey: key, alterKeys: alterKeys, optional: true)
	}
	@inlinable
	public func decode(default value: Bool?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Bool {
		try decodeBool(mainKey: key, alterKeys: alterKeys, optional: false)
	}
	
	// MARK: - String
	@inlinable
	public func decode(default value: String?, key: String, alterKeys: @autoclosure () -> [String]) throws -> String? {
		try decodeString(mainKey: key, alterKeys: alterKeys, optional: true)
	}
	@inlinable
	public func decode(default value: String?, key: String, alterKeys: @autoclosure () -> [String]) throws -> String {
		try decodeString(mainKey: key, alterKeys: alterKeys, optional: false)
	}
	
	// MARK: - Double
	@inlinable
	public func decode(default value: Double?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Double? {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Double.self)
	}
	@inlinable
	public func decode(default value: Double?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Double {
		try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Double.self)
	}
	
	// MARK: - Float
	@inlinable
	public func decode(default value: Float?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Float? {
		Float(try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Float.self))
	}
	@inlinable
	public func decode(default value: Float?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Float {
		Float(try decodeDouble(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Float.self))
	}
	
	// MARK: - Int
	@inlinable
	public func decode(default value: Int?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int? {
		Int(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int.self))
	}
	@inlinable
	public func decode(default value: Int?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int {
		Int(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int.self))
	}
	
	// MARK: - Int8
	@inlinable
	public func decode(default value: Int8?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int8? {
		Int8(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int8.self))
	}
	@inlinable
	public func decode(default value: Int8?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int8 {
		Int8(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int8.self))
	}
	
	// MARK: - Int16
	@inlinable
	public func decode(default value: Int16?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int16? {
		Int16(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int16.self))
	}
	@inlinable
	public func decode(default value: Int16?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int16 {
		Int16(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int16.self))
	}
	
	// MARK: - Int32
	@inlinable
	public func decode(default value: Int32?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int32? {
		Int32(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int32.self))
	}
	@inlinable
	public func decode(default value: Int32?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int32 {
		Int32(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int32.self))
	}
	
	// MARK: - Int64
	@inlinable
	public func decode(default value: Int64?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int64? {
		Int64(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: Int64.self))
	}
	@inlinable
	public func decode(default value: Int64?, key: String, alterKeys: @autoclosure () -> [String]) throws -> Int64 {
		Int64(try decodeInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: Int64.self))
	}
	
	// MARK: - UInt
	@inlinable
	public func decode(default value: UInt?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt? {
		UInt(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt.self))
	}
	@inlinable
	public func decode(default value: UInt?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt {
		UInt(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt.self))
	}
	
	// MARK: - UInt8
	@inlinable
	public func decode(default value: UInt8?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt8? {
		UInt8(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt8.self))
	}
	@inlinable
	public func decode(default value: UInt8?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt8 {
		UInt8(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt8.self))
	}
	
	// MARK: - UInt16
	@inlinable
	public func decode(default value: UInt16?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt16? {
		UInt16(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt16.self))
	}
	@inlinable
	public func decode(default value: UInt16?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt16 {
		UInt16(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt16.self))
	}
	
	// MARK: - UInt32
	@inlinable
	public func decode(default value: UInt32?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt32? {
		UInt32(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt32.self))
	}
	@inlinable
	public func decode(default value: UInt32?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt32 {
		UInt32(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt32.self))
	}
	
	// MARK: - UInt64
	@inlinable
	public func decode(default value: UInt64?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt64? {
		UInt64(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: true, targetType: UInt64.self))
	}
	@inlinable
	public func decode(default value: UInt64?, key: String, alterKeys: @autoclosure () -> [String]) throws -> UInt64 {
		UInt64(try decodeUInt(mainKey: key, alterKeys: alterKeys, optional: false, targetType: UInt64.self))
	}
}

// MARK: - Generic implementation
extension KeyedDecodingContainer where Key == StringCodingKey {
	// MARK: - Sub Interface
	// MARK: - Decodable
	@usableFromInline
	func decodeDecodable<T>(mainKey: String, alterKeys: () -> [String], optional: Bool) throws -> T where T: Decodable {
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
			for key in alterKeys() {
				let key = StringCodingKey(key)
				if let value = try? _decode(key: key) {
					return value
				}
			}
			
			throw error
		}
	}
	// MARK: - Bool
	@usableFromInline
	func decodeBool(mainKey: String, alterKeys: () -> [String], optional: Bool) throws -> Bool {
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
			for key in alterKeys() {
				let key = StringCodingKey(key)
				if let value = try? _decode(key: key) {
					return value
				}
			}
			
			throw error
		}
	}
	// MARK: - String
	@usableFromInline
	func decodeString(mainKey: String, alterKeys: () -> [String], optional: Bool) throws -> String {
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
			for key in alterKeys() {
				let key = StringCodingKey(key)
				if let value = try? _decode(key: key) {
					return value
				}
			}
			
			throw error
		}
	}
	// MARK: - Double
	@usableFromInline
	func decodeDouble<T>(mainKey: String, alterKeys: () -> [String], optional: Bool, targetType: T.Type) throws -> Double {
		func _decode(key: StringCodingKey) throws -> Double {
			do {
				if optional {
					if let value = try decodeIfPresent(Double.self, forKey: key) {
						return value
					} else {
						throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected \(T.self) value but found nothing."))
					}
				} else {
					return try decode(Double.self, forKey: key)
				}
			} catch {
				if case DecodingError.typeMismatch = error {
					if let value = try? decodeIfPresent(String.self, forKey: key), let result = Double(value) {
						return result
					}
				}
				throw error
			}
		}
		do {
			return try _decode(key: StringCodingKey(mainKey))
		} catch {
			for key in alterKeys() {
				let key = StringCodingKey(key)
				if let value = try? _decode(key: key) {
					return value
				}
			}
			
			throw error
		}
	}
	
	// MARK: - Int
	@usableFromInline
	func decodeInt<T>(mainKey: String, alterKeys: () -> [String], optional: Bool, targetType: T.Type) throws -> Int64 where T: FixedWidthInteger {
		func boundsCheck(value: Int64, for key: StringCodingKey) throws -> Int64 {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return value
		}
		func _decode(key: StringCodingKey) throws -> Int64 {
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
			for key in alterKeys() {
				let key = StringCodingKey(key)
				if let value = try? _decode(key: key) {
					return value
				}
			}
			
			throw error
		}
	}
	
	// MARK: - UInt
	@usableFromInline
	func decodeUInt<T>(mainKey: String, alterKeys: () -> [String], optional: Bool, targetType: T.Type) throws -> UInt64 where T: FixedWidthInteger {
		func boundsCheck(value: UInt64, for key: StringCodingKey) throws -> UInt64 {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return value
		}
		func _decode(key: StringCodingKey) throws -> UInt64 {
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
			for key in alterKeys() {
				let key = StringCodingKey(key)
				if let value = try? _decode(key: key) {
					return value
				}
			}
			
			throw error
		}
	}
}
