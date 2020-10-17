//
//  DynamicDefaultTest.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/9/26.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
@testable import Demo

class DynamicDefaultTest: XCTestCase {

	func test() throws {
		let fakeData_Int = Int.random(in: 0...1000000000)
		let json: NSDictionary = [
			"intDynamic": fakeData_Int,
			"intStatic": fakeData_Int
		]
		
		assert(try TestStruct_dynamicDefault.decode(from: json).toJSON() as NSDictionary == json)
		
		// 这个目前过不了Swift 有bug, 转换property wrapper的时候会把@autoclosure给调用后再传值
		assert((try TestStruct_dynamicDefault.decode(from: [:])).intDynamic != (try TestStruct_dynamicDefault.decode(from: [:])).intDynamic)
		
		assert((try TestStruct_dynamicDefault.decode(from: [:])).intStatic == (try TestStruct_dynamicDefault.decode(from: [:])).intStatic)
	}
}
