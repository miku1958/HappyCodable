//
//  HappyCodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/5/23.
//

import Foundation

enum HappyCodableAccessibility: String {
	case `fileprivate`, `private`, `internal`, `public`
}
// MARK: - HappyCodableSerialization
public protocol HappyCodableSerialization {
	
}

// MARK: - Type
// MARK: - HappyEncodable
public protocol HappyEncodable: Encodable, HappyCodableSerialization {
	static var globalEncodeSafely: Bool { get }
	func encode(happyTo encoder: Encoder) throws
}

extension HappyEncodable {
	public static var globalEncodeSafely: Bool { true }
	public func encode(to encoder: Encoder) throws {
		try encode(happyTo: encoder)
	}
	func encode(happyTo encoder: Encoder) throws {
		
	}
}

// MARK: - HappyDecodable
public protocol HappyDecodable: Decodable, HappyCodableSerialization {
	init()
	static var globalDecodeAllowOptional: Bool { get }
	mutating func decode(happyFrom decoder: Decoder) throws
	
	mutating func willStartMapping()
	mutating func didFinishMapping()
}

extension HappyDecodable {
	public static var globalDecodeAllowOptional: Bool { true }
	public init(from decoder: Decoder) throws {
		self.init()
		try self.decode(happyFrom: decoder)
	}
	mutating func decode(happyFrom decoder: Decoder) throws {
		
	}
	
	mutating public func willStartMapping() {
		
	}
	mutating public func didFinishMapping() {
		
	}
}

// MARK: - HappyCodable
public typealias HappyCodable = HappyEncodable & HappyDecodable

// MARK: - Enum
/// use for Enum which not base on RawRepresentable
public protocol HappyEncodableEnum: Encodable, HappyCodableSerialization {
	func encode(happyTo encoder: Encoder) throws
}

extension HappyEncodableEnum {
	public func encode(to encoder: Encoder) throws {
		try encode(happyTo: encoder)
	}
	public func encode(happyTo encoder: Encoder) throws {
		
	}
}

// MARK: - HappyDecodable
/// use for Enum which not base on RawRepresentable
/// wraming: HappyDecodableEnum is
public protocol HappyDecodableEnum: Decodable, HappyCodableSerialization {
	init(happyFrom decoder: Decoder) throws
}

extension HappyDecodableEnum {
	public init(from decoder: Decoder) throws {
		try self.init(happyFrom: decoder)
	}
	public init(happyFrom decoder: Decoder) throws {
		fatalError()
	}
}

// MARK: - HappyCodable
/// use for Enum which not base on RawRepresentable
public typealias HappyCodableEnum = HappyEncodableEnum & HappyDecodableEnum
