////
////  Person.swift
////  HappyCodableDemo
////
////  Created by 庄黛淳华 on 2020/5/23.
////  Copyright © 2020 庄黛淳华. All rights reserved.
////
//
//import Foundation
//import HappyCodable
//
//
//struct Person: HappyCodable {
//	var name1: String = "abc"
//	
//	@Happy.codingKeys("🍉")
//	var numberOfTips2: String = "abc"
//	
//	@Happy.codingKeys("234", "age", "abc")
//	var age: String = "abc"
//	
//	@Happy.uncoding
//	var abc: String = "abc" // build fail if coded
//}
//
//struct Test {
//	struct Person2 {
//		var name: String = "abc"
//		
//		@Happy.uncoding
//		var numberOfTips: String = "abc"
//		
//		@Happy.codingKeys("234")
//		var age2 = Person()
//	}
//}
//
//extension Test.Person2: HappyCodable {
//	var id: Int { 0 }
//}
//
//struct Person3: HappyCodable {
//	fileprivate let accessibility1 = 1
//	private let accessibility2 = 1
//	internal let accessibility3 = 1
//	public let accessibility4 = 1
//	public var accessibility5 = 1
//	var get_set: Bool = false
//	var getter: Bool {
//		true
//	}
//}
//
//
//final class Person4: HappyCodable {
//	var accessibility1 = 1
//	public let accessibility2 = 1
//	var accessibility3 = 1
//	enum CodingKeys: Int, CodingKey {
//		case accessibility1
//		case accessibility3
//	}
//}
//
//enum EnumTest: HappyCodableEnum {
//	case value(num: Int, name: String)
////	case call(() -> Void) // build fail if added
//	case name0(String)
//	case name1(String, last: String)
//	case name2(first: String, String)
//	case name3(_ first: String, _ last: String)
//}
