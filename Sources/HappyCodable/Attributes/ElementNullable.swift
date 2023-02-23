//
//  ElementNullable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/21.
//

import Foundation

extension Happy {
	@propertyWrapper
	final public class elementNullable<T> {
		var storage: [T]?
		var constructor: (() -> [T])?
		
		public var wrappedValue: [T] {
			get {
				if let value = storage {
					return value
				}
				storage = constructor?()
				return storage!
			}
			set {
				storage = newValue
			}
		}

		init(storage: [T]) {
			self.storage = storage
		}

		public init(wrappedValue constructor: @escaping @autoclosure () -> [T]) {
			self.constructor = constructor
		}
	}
}

extension Happy.elementNullable: GenericTypeAttribute {
	
}
extension Happy.elementNullable: Equatable where T: Equatable {
	public static func == (lhs: Happy.elementNullable<T>, rhs: Happy.elementNullable<T>) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
}

extension Happy.elementNullable: Hashable where T: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(wrappedValue)
	}
}

extension Happy.elementNullable: Decodable where T: Decodable {
	public convenience init(from decoder: Decoder) throws {
		fatalError()
	}
}

extension Happy.elementNullable: Encodable where T: Encodable {
	public func encode(to encoder: Encoder) throws {
		try wrappedValue.encode(to: encoder)
	}
}

extension KeyedDecodingContainer {
	public func decode<T>(_ type: Happy.elementNullable<T>.Type, forKey key: Key) throws -> Happy.elementNullable<T> where T: Decodable {

		let collection = try decode([T?].self, forKey: key)
			.compactMap { $0 }

		return .init(storage: collection)
	}
}

// MARK: - KeyedEncodingContainer
extension KeyedEncodingContainer {
	public mutating func encode<T>(_ value: Happy.elementNullable<T>, forKey key: Key) throws where T: Encodable {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.ElementNullable<[T]>(defaultValue: value.constructor)
			return
		}
		try encode(RedirectCodable(direct: value), forKey: key)
	}
}
