//
//  HappyCodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/5/23.
//

import Foundation


// MARK: - HappyCodableSerialization
public protocol HappyCodableSerialization {
	
}

// MARK: - Type
// MARK: - HappyEncodable
public protocol HappyEncodable: Encodable, HappyCodableSerialization {
	static var allowHappyEncodableSafely: Bool { get }
	func encode(happyTo encoder: Encoder) throws
}

extension HappyEncodable {
	public static var allowHappyEncodableSafely: Bool { true }
	public func encode(to encoder: Encoder) throws {
		try encode(happyTo: encoder)
	}
	public func encode(happyTo encoder: Encoder) throws {
		assertionFailure("HappyEncodable did not work, assuming it is applying HappyEncodable to a private Type? You should not do this.")
	}
}

// MARK: - HappyDecodable
public protocol HappyDecodable: Decodable, HappyCodableSerialization {
	init()
	static var allowHappyDecodableSkipMissing: Bool { get }
	mutating func decode(happyFrom decoder: Decoder) throws
	
	mutating func willStartMapping()
	mutating func didFinishMapping()
}

extension HappyDecodable {
	public static var allowHappyDecodableSkipMissing: Bool { true }
	public init(from decoder: Decoder) throws {
		self.init()
		try self.decode(happyFrom: decoder)
	}
	public mutating func decode(happyFrom decoder: Decoder) throws {
		assertionFailure("HappyDecodable did not work, assuming it is applying HappyDecodable to a private Type? You should not do this.")
	}
	
	public mutating func willStartMapping() {
		
	}
	public mutating func didFinishMapping() {
		
	}
}

// MARK: - HappyCodable
public typealias HappyCodable = HappyEncodable & HappyDecodable

// MARK: - Enum
/// use for Enum which not base on RawRepresentable
public protocol HappyEncodableEnum: Encodable, HappyCodableSerialization {
	
}

extension HappyEncodableEnum {
	public func encode(to encoder: Encoder) throws {
		assertionFailure("HappyEncodableEnum did not work, assuming it is applying HappyDecodable to a private Type? You should not do this.")
	}
}

// MARK: - HappyDecodable
/// use for Enum which not base on RawRepresentable
/// wraming: HappyDecodableEnum is
public protocol HappyDecodableEnum: Decodable, HappyCodableSerialization {
	
}

extension HappyDecodableEnum {
	public init(from decoder: Decoder) throws {
		fatalError("HappyDecodableEnum did not work, assuming it is applying HappyDecodableEnum to a private Enum? You should not do this.")
	}
}

// MARK: - HappyCodable
/// use for Enum which not base on RawRepresentable
public typealias HappyCodableEnum = HappyEncodableEnum & HappyDecodableEnum
