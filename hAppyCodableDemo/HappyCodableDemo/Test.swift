////
////  Person.swift
////  HappyCodableDemo
////
////  Created by 庄黛淳华 on 2020/5/23.
////  Copyright © 2020 庄黛淳华. All rights reserved.
////

import Foundation
import HappyCodable

struct Person: HappyCodable {
	var name: String = "abc"
	
	@Happy.codingKeys("🆔")
	var id: String = "abc"
	
	@Happy.codingKeys("secret_number", "age") // the first key will be the coding key
	var age: Int = 18
	
	@Happy.uncoding
	var secret_number: String = "3.1415" // Build fail if coded, in this case, we can "uncoding" it.
}

enum EnumTest: HappyCodableEnum {
	case value(num: Int, name: String)
	//	case call(() -> Void) // Build fails if added, since (() -> Void) can't be codable
	case name0(String)
	case name1(String, last: String)
	case name2(first: String, String)
	case name3(_ first: String, _ last: String)
}
