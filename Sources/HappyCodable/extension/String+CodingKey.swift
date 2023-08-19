//
//  String+CodingKey.swift
//  HappyCodable
//
//

import Foundation

extension String: CodingKey {
	public init?(stringValue: String) {
		self = stringValue
	}

	@inlinable
	@inline(__always)
	public var stringValue: String { self }

	public init?(intValue: Int) { return nil }
	public var intValue: Int? { nil }
}
