//
//  DataCodingStrategyTest.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/9/25.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
#if canImport(Demo)
@testable import Demo
#endif

class DataCodingStrategyTest: XCTestCase {
	func test() {
		let fakeData_string = "\(Int.random(in: 0...1000000000))"
		let fakeData_data = fakeData_string.data(using: .utf8)!
		
		let json: NSMutableDictionary = [
			
			"date_deferredToDate": Array(fakeData_data),
		
			"date_base64": fakeData_data.base64EncodedString(),
		
			"date_custom": Array(fakeData_data)
		]
		let object = try! TestStruct_dataStrategy.decode(from: json)
		
		assert(try object.toJSON() as NSDictionary != json)
		json["date_custom"] = Array(TestStruct_dataStrategy.customData)
		assert(try object.toJSON() as NSDictionary == json)
	}
	func testNull() {
		let json: NSMutableDictionary = [
			
			"date_deferredToDate": NSNull(),
		
			"date_base64": NSNull(),
		
			"date_custom": NSNull()
		]
		let object = try! TestStruct_dataStrategy.decode(from: json)
		
		assert(try object.toJSON() as NSDictionary != json)
		
		assert(object.date_deferredToDate == TestStruct_dataStrategy.defaultData)
		assert(object.date_base64 == TestStruct_dataStrategy.defaultData)
		assert(object.date_custom == TestStruct_dataStrategy.defaultData)
	}
}
