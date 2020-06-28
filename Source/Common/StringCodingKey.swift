//
//  StringCodingKey.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/28.
//

import Foundation

struct StringCodingKey: CodingKey {
	var stringValue: String
	var intValue: Int?
	
	init(_ string: String) {
		stringValue = string
	}
	
	init?(stringValue: String) {
		self.stringValue = stringValue
	}
	
	init?(intValue: Int) {
		self.intValue = intValue
		self.stringValue = String(intValue)
	}
}
