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
		enum Error: Swift.Error {
			case noDefaultValueFound
		}
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
	static func decode<K>(container: KeyedDecodingContainer<K>, forKey key: K) throws -> Self where K : CodingKey {
		do {
			if let value = try container.decodeIfPresent(T.self, forKey: key) {
				return .init(value)
			} else {
				guard
					let decoder = Thread.decoder?(),
					let attribute = decoder.dealingModel.decodeAttributes[key.stringValue] as? ModelCache.DynamicDefault<T>
				else {
					throw Error.noDefaultValueFound
				}
				return .init(attribute.defaultValue)
			}
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
	// MARK: - Decodable
	public func decode<T>(_ type: Happy.dynamicDefault<T>.Type, forKey key: Key) throws -> Happy.dynamicDefault<T> where T: Decodable {
		try .decode(container: self, forKey: key)
	}
}

// MARK: - KeyedEncodingContainer
extension KeyedEncodingContainer {
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
