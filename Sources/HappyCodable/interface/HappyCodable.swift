//
//  HappyCodable.swift
//  HappyCodable
//
//

import Foundation

// MARK: - Type
// MARK: - HappyEncodable
public protocol HappyEncodable: Encodable {
	mutating func willStartEncoding()
	static var encodeHelper: EncodeHelper { get }
}

public protocol HappyDecodable: Decodable {
	mutating func didFinishDecoding()
	static var decodeHelper: DecodeHelper { get }
}

public typealias HappyCodable = HappyEncodable & HappyDecodable
