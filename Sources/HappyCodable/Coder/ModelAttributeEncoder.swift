//
//  ModelAttributeEncoder.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/24.
//

import Foundation

final class ModelAttributeEncoder: Encoder {
	let modelType: Any.Type
	lazy var cachingModel = ModelCache(modelType: modelType)
	
	init(modelType: Any.Type) {
		self.modelType = modelType
	}

	func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
		KeyedEncodingContainer(Container(encoder: self))
	}
	struct Container<Key: CodingKey>: KeyedEncodingContainerProtocol {
		let encoder: ModelAttributeEncoder
		
		mutating func encodeNil(forKey key: Key) throws { }
		
		mutating func encode(_ value: Bool, forKey key: Key) throws { }
		
		mutating func encode(_ value: String, forKey key: Key) throws { }
		
		mutating func encode(_ value: Double, forKey key: Key) throws { }
		
		mutating func encode(_ value: Float, forKey key: Key) throws { }
		
		mutating func encode(_ value: Int, forKey key: Key) throws { }
		
		mutating func encode(_ value: Int8, forKey key: Key) throws { }
		
		mutating func encode(_ value: Int16, forKey key: Key) throws { }
		
		mutating func encode(_ value: Int32, forKey key: Key) throws { }
		
		mutating func encode(_ value: Int64, forKey key: Key) throws { }
		
		mutating func encode(_ value: UInt, forKey key: Key) throws { }
		
		mutating func encode(_ value: UInt8, forKey key: Key) throws { }
		
		mutating func encode(_ value: UInt16, forKey key: Key) throws { }
		
		mutating func encode(_ value: UInt32, forKey key: Key) throws { }
		
		mutating func encode(_ value: UInt64, forKey key: Key) throws { }
		
		mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable { }
		
		var codingPath: [CodingKey] { fatalError() }
		mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey { fatalError() }
		mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer { fatalError() }
		mutating func superEncoder() -> Encoder { fatalError() }
		mutating func superEncoder(forKey key: Key) -> Encoder { fatalError() }
	}
	
	var codingPath: [CodingKey] { fatalError() }
	var userInfo: [CodingUserInfoKey: Any] { fatalError() }
	func unkeyedContainer() -> UnkeyedEncodingContainer { fatalError() }
	func singleValueContainer() -> SingleValueEncodingContainer { fatalError() }
}
