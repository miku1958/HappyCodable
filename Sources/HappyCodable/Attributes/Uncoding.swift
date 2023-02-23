//
//  Uncoding.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/21.
//

import Foundation

extension Happy {
	@propertyWrapper
	final public class uncoding<T> {
		var storage: T?
		var constructor: () -> T
		
		public var wrappedValue: T {
			get {
				if let value = storage {
					return value
				}
				storage = constructor()
				return storage!
			}
			set {
				storage = newValue
			}
		}
		
		init(constructor: @escaping () -> T) {
			self.constructor = constructor
		}
		public init(wrappedValue constructor: @escaping @autoclosure () -> T) {
			self.constructor = constructor
		}
		public init<Wrapped>() where T == Wrapped? {
			constructor = { nil }
		}
	}
}

extension Happy.uncoding: Equatable where T: Equatable {
	public static func == (lhs: Happy.uncoding<T>, rhs: Happy.uncoding<T>) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
}
extension Happy.uncoding: Hashable where T: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(wrappedValue)
	}
}

extension Happy.uncoding: Codable {
	public convenience init(from decoder: Decoder) throws {
		fatalError()
	}
	public func encode(to encoder: Encoder) throws {
		
	}
}

extension Happy.uncoding: GenericTypeAttribute {
	static func decode<K>(container: KeyedDecodingContainer<K>, forKey key: K) throws -> Self where K : CodingKey {
		guard let decoder = Thread.decoder?() else {
			throw DecodeError.unsupportedDecoder
		}
		let attribute = decoder.dealingModel.decodeAttributes[key.stringValue] as! ModelCache.Uncoding<T>
		return .init(constructor: attribute.defaultValue)
	}
}

// MARK: - KeyedDecodingContainer
extension KeyedDecodingContainer {
	public func decode<T>(_ type: Happy.uncoding<T>.Type, forKey key: Key) throws -> Happy.uncoding<T> {
		try .decode(container: self, forKey: key)
	}
}

// MARK: - KeyedEncodingContainer
extension KeyedEncodingContainer {
	public mutating func encode<T>(_ value: Happy.uncoding<T>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.Uncoding(defaultValue: value.constructor)
			return
		}
		
		try encode(RedirectCodable(direct: value), forKey: key)
	}
}
