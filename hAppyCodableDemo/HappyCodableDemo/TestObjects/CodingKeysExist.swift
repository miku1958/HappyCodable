//
//  CodingKeysExist.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/8/1.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct CodingKeysExistStruct: HappyCodable, Equatable {
	var int: Int = 0
	var string: String = ""
	var bool: Bool = false
	enum CodingKeys: String, CodingKey {
		case int = "int_alter"
		case string = "string_alter"
		case bool
	}
}
