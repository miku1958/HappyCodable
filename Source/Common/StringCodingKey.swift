//
//  StringCodingKey.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/28.
//

#if canImport(Foundation)
import Foundation
#endif

public struct StringCodingKey: CodingKey {
	public var stringValue: String
	public var intValue: Int?
	
	init(_ string: String) {
		stringValue = string
	}
	
	public init?(stringValue: String) {
		self.stringValue = stringValue
	}
	
	public init?(intValue: Int) {
		self.intValue = intValue
		self.stringValue = String(intValue)
	}
}
