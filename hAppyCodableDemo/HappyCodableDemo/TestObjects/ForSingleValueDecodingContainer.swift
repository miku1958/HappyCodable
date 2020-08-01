//
//  ForSingleValueDecodingContainer.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/8/1.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

enum TestEnumInt: Int, HappyCodableEnum {
	case one = 1
	case two = 2
}
enum TestEnumDouble: Double, HappyCodableEnum {
	case pi = 3.1415
	case two = 2
}
enum TestEnumString: String, HappyCodableEnum {
	case `true`
	case int = "123"
	case double = "3.14"
}
