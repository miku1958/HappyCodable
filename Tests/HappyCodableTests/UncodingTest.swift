//
//  UncodingTest.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/9/26.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
#if canImport(Demo)
@testable import Demo
#endif

class UncodingTest: XCTestCase {
	func test() {
		let fakeData_Int = Int.random(in: 0...1000000000)
		let json: NSDictionary = [
			"uncoing": fakeData_Int,
			"uncoingOptional": [
				"int": fakeData_Int
			]
		]
		let object = try! TestStruct_uncoding.decode(from: json)
		assert(object.uncoingOptional == nil)
		
		assert(object.uncoing == TestStruct_uncoding().uncoing)
		
		assert((try object.toJSON() as NSDictionary) == [
			"uncoing": [:],
			"uncoingOptional": [:]
		])
	}
}
