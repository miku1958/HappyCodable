//
//  Attributes.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation

// MARK: - HappyCodableGenericTypeCodable

protocol HappyCodableGenericTypeCodable: Codable, CustomDebugStringConvertible, CustomStringConvertible {
	associatedtype T: Codable
	var wrappedValue: T { get set }
	init(wrappedValue: T)
}

extension HappyCodableGenericTypeCodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(wrappedValue: try container.decode(T.self))
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(wrappedValue)
	}
}

extension HappyCodableGenericTypeCodable {
	public var debugDescription: String {
		String(describing: wrappedValue)
	}
	
	public var description: String {
		String(describing: wrappedValue)
	}
}

// MARK: - Attributes
public struct Happy {
	// MARK: - codingKeys
	@propertyWrapper
	public struct codingKeys<T>: HappyCodableGenericTypeCodable where T: Codable {
		public struct String: ExpressibleByStringLiteral {
			let _string: Swift.String
			/// do not use this directly! use string literal!
			public init(stringLiteral value: Swift.String) {
				_string = value
			}
		}
		
		public var wrappedValue: T
		public init(wrappedValue: T, _ codingKeys: String...) {
			self.wrappedValue = wrappedValue
		}
		public init(wrappedValue: T) {
			self.wrappedValue = wrappedValue
		}
		public init<Wrapped>(_ codingKeys: String...) where T == Wrapped? {
			self.wrappedValue = nil
		}
	}
	
	// MARK: - optional
	@propertyWrapper
	public struct optional<T>: HappyCodableGenericTypeCodable where T: Codable {
		public var wrappedValue: T
		
		public init(wrappedValue: T) {
			self.wrappedValue = wrappedValue
		}
		public init<Wrapped>() where T == Wrapped? {
			self.wrappedValue = nil
		}
	}
	
	// MARK: - uncoding
	@propertyWrapper
	public struct uncoding<T>: CustomDebugStringConvertible, CustomStringConvertible {
		public var wrappedValue: T
		
		public init(wrappedValue: T) {
			self.wrappedValue = wrappedValue
		}
		public init<Wrapped>() where T == Wrapped? {
			self.wrappedValue = nil
		}
		public var debugDescription: String {
			String(describing: wrappedValue)
		}
		public var description: String {
			String(describing: wrappedValue)
		}
	}
}
