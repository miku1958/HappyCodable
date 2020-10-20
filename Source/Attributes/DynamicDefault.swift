//
//  DynamicDefault.swift
//  Pods
//
//  Created by 庄黛淳华 on 2020/9/25.
//

import Foundation

extension Happy {
	@propertyWrapper
	final public class dynamicDefault<T: Codable> {
		var storage: T?
		var constructor: (() -> T)?
		
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

		public init(wrappedValue constructor: @escaping @autoclosure () -> T) {
			self.constructor = constructor
		}
		
		init(_ wrappedValue: T)  {
			self.storage = wrappedValue
		}
		
		init(_ wrappedValue: (() -> T)?) {
			self.constructor = wrappedValue
		}
	}
}

extension Happy.dynamicDefault: GenericTypeAttribute {
	
}
extension Happy.dynamicDefault: Equatable where T: Equatable {
	public static func == (lhs: Happy.dynamicDefault<T>, rhs: Happy.dynamicDefault<T>) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
}
extension Happy.dynamicDefault: Hashable where T: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(wrappedValue)
	}
}

// This should be handled by KeyedDecodingContainer.
extension Happy.dynamicDefault: Codable {
	public convenience init(from decoder: Decoder) throws {
		fatalError()
	}
	
	public func encode(to encoder: Encoder) throws {
		fatalError()
	}
}

// MARK: - KeyedDecodingContainer
extension KeyedDecodingContainer {
	private func dynamicDefault<T>(_ finish: () throws -> T, forKey key: Key) rethrows -> Happy.dynamicDefault<T> {
		do {
			let value = try finish()
			return .init(value)
		} catch {
			guard
				let decoder = Thread.decoder?(),
				let attribute = decoder.dealingModel.decodeAttributes[key.stringValue] as? ModelCache.DynamicDefault<T>
				else {
					throw error
			}
			return .init(attribute.defaultValue)
		}
	}
	// MARK: - Decodable
	public func decode<T>(_ type: Happy.dynamicDefault<T?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<T?> where T: Decodable {
		try dynamicDefault({
			try decodeIfPresent(T.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode<T>(_ type: Happy.dynamicDefault<T>.Type, forKey key: Key) throws -> Happy.dynamicDefault<T> where T: Decodable {
		try dynamicDefault({
			try decode(T.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Bool
	
	public func decode(_ type: Happy.dynamicDefault<Bool?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Bool?> {
		try dynamicDefault({
			try decodeIfPresent(Bool.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Bool>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Bool> {
		try dynamicDefault({
			try decode(Bool.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - String
	
	public func decode(_ type: Happy.dynamicDefault<String?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<String?> {
		try dynamicDefault({
			try decodeIfPresent(String.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<String>.Type, forKey key: Key) throws -> Happy.dynamicDefault<String> {
		try dynamicDefault({
			try decode(String.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Double
	
	public func decode(_ type: Happy.dynamicDefault<Double?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Double?> {
		try dynamicDefault({
			try decodeIfPresent(Double.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Double>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Double> {
		try dynamicDefault({
			try decode(Double.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Float
	
	public func decode(_ type: Happy.dynamicDefault<Float?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Float?> {
		try dynamicDefault({
			try decodeIfPresent(Float.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Float>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Float> {
		try dynamicDefault({
			try decode(Float.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int
	
	public func decode(_ type: Happy.dynamicDefault<Int?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int?> {
		try dynamicDefault({
			try decodeIfPresent(Int.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Int>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int> {
		try dynamicDefault({
			try decode(Int.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int8
	
	public func decode(_ type: Happy.dynamicDefault<Int8?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int8?> {
		try dynamicDefault({
			try decodeIfPresent(Int8.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Int8>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int8> {
		try dynamicDefault({
			try decode(Int8.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int16
	
	public func decode(_ type: Happy.dynamicDefault<Int16?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int16?> {
		try dynamicDefault({
			try decodeIfPresent(Int16.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Int16>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int16> {
		try dynamicDefault({
			try decode(Int16.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int32
	
	public func decode(_ type: Happy.dynamicDefault<Int32?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int32?> {
		try dynamicDefault({
			try decodeIfPresent(Int32.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Int32>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int32> {
		try dynamicDefault({
			try decode(Int32.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - Int64
	
	public func decode(_ type: Happy.dynamicDefault<Int64?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int64?> {
		try dynamicDefault({
			try decodeIfPresent(Int64.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<Int64>.Type, forKey key: Key) throws -> Happy.dynamicDefault<Int64> {
		try dynamicDefault({
			try decode(Int64.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt
	
	public func decode(_ type: Happy.dynamicDefault<UInt?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt?> {
		try dynamicDefault({
			try decodeIfPresent(UInt.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<UInt>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt> {
		try dynamicDefault({
			try decode(UInt.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt8
	
	public func decode(_ type: Happy.dynamicDefault<UInt8?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt8?> {
		try dynamicDefault({
			try decodeIfPresent(UInt8.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<UInt8>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt8> {
		try dynamicDefault({
			try decode(UInt8.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt16
	
	public func decode(_ type: Happy.dynamicDefault<UInt16?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt16?> {
		try dynamicDefault({
			try decodeIfPresent(UInt16.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<UInt16>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt16> {
		try dynamicDefault({
			try decode(UInt16.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt32
	
	public func decode(_ type: Happy.dynamicDefault<UInt32?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt32?> {
		try dynamicDefault({
			try decodeIfPresent(UInt32.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<UInt32>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt32> {
		try dynamicDefault({
			try decode(UInt32.self, forKey: key)
		}, forKey: key)
	}
	
	// MARK: - UInt64
	
	public func decode(_ type: Happy.dynamicDefault<UInt64?>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt64?> {
		try dynamicDefault({
			try decodeIfPresent(UInt64.self, forKey: key)
		}, forKey: key)
	}
	
	public func decode(_ type: Happy.dynamicDefault<UInt64>.Type, forKey key: Key) throws -> Happy.dynamicDefault<UInt64> {
		try dynamicDefault({
			try decode(UInt64.self, forKey: key)
		}, forKey: key)
	}
}

// MARK: - KeyedEncodingContainer
extension KeyedEncodingContainer {
	public mutating func encode(_ value: Happy.dynamicDefault<Bool?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Bool>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<String?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<String>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<Double?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Double>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<Float?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Float>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<Int?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Int>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<Int8?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Int8>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<Int16?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Int16>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<Int32?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Int32>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<Int64?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<Int64>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<UInt?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<UInt>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<UInt8?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<UInt8>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<UInt16?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<UInt16>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<UInt32?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<UInt32>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode(_ value: Happy.dynamicDefault<UInt64?>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode(_ value: Happy.dynamicDefault<UInt64>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
	
	public mutating func encode<T>(_ value: Happy.dynamicDefault<T?>, forKey key: Key) throws where T : Encodable {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encodeIfPresent(value.wrappedValue, forKey: key)
	}
	public mutating func encode<T>(_ value: Happy.dynamicDefault<T>, forKey key: Key) throws where T : Encodable {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DynamicDefault(defaultValue: value.constructor)
			return
		}
		try encode(value.wrappedValue, forKey: key)
	}
}
