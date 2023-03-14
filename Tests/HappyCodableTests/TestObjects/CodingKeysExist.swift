//
//  CodingKeysExist.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

@HappyCodable
struct TestStruct_codingKeysExist: HappyCodable, Equatable {
	var int: Int = 0
	var string: String = ""
	var bool: Bool = false
	enum CodingKeys: String, CodingKey {
		case int = "int_alter"
		case string = "string_alter"
		case bool
	}

	init(int: Int, string: String, bool: Bool) {
		self.int = int
		self.string = string
		self.bool = bool
	}
}
