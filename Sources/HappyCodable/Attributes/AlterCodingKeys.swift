//
//  CodingKeys.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/21.
//

import Foundation
protocol CodingKeysFilter {
	
}
extension Optional: CodingKeysFilter where Wrapped: CodingKeysFilter {
	
}
extension CodingKeysFilter {
	static func precondition() {
		fatalError("Happy.alterCodingKeys should not apply to another Happy.alterCodingKeys")
	}
}
extension Happy {
	@propertyWrapper
	final public class alterCodingKeys<T: Codable> {
		var storage: T?
		let constructor: (() -> T)?
		let codingKeys: [String]
		
		public var wrappedValue: T {
			get {
				if let value = storage {
					return value
				}
				storage = constructor!()
				return storage!
			}
			set {
				storage = newValue
			}
		}
		
		public init(wrappedValue creater: @escaping @autoclosure () -> T, _ codingKeys: String...) {
			(T.self as? CodingKeysFilter.Type)?.precondition()
			
			self.constructor = creater
			self.codingKeys = codingKeys
		}
		
		public init(wrappedValue creater: @escaping @autoclosure () -> T) {
			(T.self as? CodingKeysFilter.Type)?.precondition()
			
			self.constructor = creater
			self.codingKeys = []
		}
		
		public init<Wrapped>(_ codingKeys: String...) where T == Wrapped? {
			(T.self as? CodingKeysFilter.Type)?.precondition()
			
			self.constructor = { nil }
			self.codingKeys = codingKeys
		}
		
		init(_ wrappedValue: T) {
			self.storage = wrappedValue
			self.constructor = nil
			self.codingKeys = []
		}
		init(_ constructor: (() -> T)?) {
			self.constructor = constructor
			self.codingKeys = []
		}
	}
}

extension Happy.alterCodingKeys: GenericTypeAttribute, CodingKeysFilter {
	
}
extension Happy.alterCodingKeys: Equatable where T: Equatable {
	public static func == (lhs: Happy.alterCodingKeys<T>, rhs: Happy.alterCodingKeys<T>) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
}
extension Happy.alterCodingKeys: Hashable where T: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(wrappedValue)
	}
}

// This should be handled by KeyedDecodingContainer.
extension Happy.alterCodingKeys: Codable {
	public convenience init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(try container.decode(T.self))
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(storage)
	}
}

// MARK: - KeyedDecodingContainer
extension KeyedDecodingContainer {
	private func alterCodingKeys<T>(_ finish: () throws -> T, forKey key: Key) rethrows -> Happy.alterCodingKeys<T> {
		do {
			let value = try finish()
			return .init(value)
		} catch {
			guard
				let decoder = Thread.decoder?(),
				let attribute = decoder.dealingModel.decodeAttributes[key.stringValue] as? ModelCache.AlterCodingKeys<T>
			else {
				throw error
			}
			return .init(attribute.defaultValue)
		}
	}
	// MARK: - Decodable
	
	public func decode<T>(_ type: Happy.alterCodingKeys<T?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<T?> where T: Decodable {
		try alterCodingKeys({
			try decodeIfPresent(T.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode<T>(_ type: Happy.alterCodingKeys<T>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<T> where T: Decodable {
		try alterCodingKeys({
			try decode(T.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Bool
	
	public func decode(_ type: Happy.alterCodingKeys<Bool?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Bool?> {
		try alterCodingKeys({
			try decodeIfPresent(Bool.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Bool>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Bool> {
		try alterCodingKeys({
			try decode(Bool.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - String
	
	public func decode(_ type: Happy.alterCodingKeys<String?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<String?> {
		try alterCodingKeys({
			try decodeIfPresent(String.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<String>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<String> {
		try alterCodingKeys({
			try decode(String.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Double
	
	public func decode(_ type: Happy.alterCodingKeys<Double?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Double?> {
		try alterCodingKeys({
			try decodeIfPresent(Double.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Double>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Double> {
		try alterCodingKeys({
			try decode(Double.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Float
	
	public func decode(_ type: Happy.alterCodingKeys<Float?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Float?> {
		try alterCodingKeys({
			try decodeIfPresent(Float.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Float>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Float> {
		try alterCodingKeys({
			try decode(Float.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int
	
	public func decode(_ type: Happy.alterCodingKeys<Int?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int?> {
		try alterCodingKeys({
			try decodeIfPresent(Int.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Int>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int> {
		try alterCodingKeys({
			try decode(Int.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int8
	
	public func decode(_ type: Happy.alterCodingKeys<Int8?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int8?> {
		try alterCodingKeys({
			try decodeIfPresent(Int8.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Int8>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int8> {
		try alterCodingKeys({
			try decode(Int8.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int16
	
	public func decode(_ type: Happy.alterCodingKeys<Int16?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int16?> {
		try alterCodingKeys({
			try decodeIfPresent(Int16.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Int16>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int16> {
		try alterCodingKeys({
			try decode(Int16.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int32
	
	public func decode(_ type: Happy.alterCodingKeys<Int32?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int32?> {
		try alterCodingKeys({
			try decodeIfPresent(Int32.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Int32>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int32> {
		try alterCodingKeys({
			try decode(Int32.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int64
	
	public func decode(_ type: Happy.alterCodingKeys<Int64?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int64?> {
		try alterCodingKeys({
			try decodeIfPresent(Int64.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<Int64>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<Int64> {
		try alterCodingKeys({
			try decode(Int64.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt
	
	public func decode(_ type: Happy.alterCodingKeys<UInt?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt?> {
		try alterCodingKeys({
			try decodeIfPresent(UInt.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<UInt>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt> {
		try alterCodingKeys({
			try decode(UInt.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt8
	
	public func decode(_ type: Happy.alterCodingKeys<UInt8?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt8?> {
		try alterCodingKeys({
			try decodeIfPresent(UInt8.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<UInt8>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt8> {
		try alterCodingKeys({
			try decode(UInt8.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt16
	
	public func decode(_ type: Happy.alterCodingKeys<UInt16?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt16?> {
		try alterCodingKeys({
			try decodeIfPresent(UInt16.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<UInt16>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt16> {
		try alterCodingKeys({
			try decode(UInt16.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt32
	
	public func decode(_ type: Happy.alterCodingKeys<UInt32?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt32?> {
		try alterCodingKeys({
			try decodeIfPresent(UInt32.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<UInt32>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt32> {
		try alterCodingKeys({
			try decode(UInt32.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt64
	
	public func decode(_ type: Happy.alterCodingKeys<UInt64?>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt64?> {
		try alterCodingKeys({
			try decodeIfPresent(UInt64.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.alterCodingKeys<UInt64>.Type, forKey key: Key) throws -> Happy.alterCodingKeys<UInt64> {
		try alterCodingKeys({
			try decode(UInt64.self, forKey: key)
		}, forKey: key)
	}
}

// MARK: - KeyedEncodingContainer
extension KeyedEncodingContainer {
	public mutating func encode(_ value: Happy.alterCodingKeys<Bool?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Bool>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<String?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<String>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<Double?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Double>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<Float?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Float>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<Int?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Int>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<Int8?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Int8>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<Int16?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Int16>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<Int32?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Int32>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<Int64?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<Int64>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt8?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt8>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt16?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt16>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt32?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt32>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt64?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.alterCodingKeys<UInt64>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode<T>(_ value: Happy.alterCodingKeys<T?>, forKey key: Key) throws where T: Encodable {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode<T>(_ value: Happy.alterCodingKeys<T>, forKey key: Key) throws where T: Encodable {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.AlterCodingKeys(alterKeys: value.codingKeys, defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
}
