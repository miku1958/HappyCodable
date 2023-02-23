//
//  Attributes.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation


// MARK: - GenericTypeCodable

enum GenericTypeAttributeError: Swift.Error {
	case noStaticDecode
}

protocol GenericTypeAttribute {
	typealias Error = GenericTypeAttributeError
	static func decode<K: CodingKey>(container: KeyedDecodingContainer<K>, forKey key: K) throws -> Self
}

// MARK: - Attributes
public struct Happy { }
