//
//  DataCodingStrategyTest.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/9/25.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
@testable import Demo

class DataCodingStrategyTest: XCTestCase {
	func test() throws {
		let fakeData_string = "\(Int.random(in: 0...1000000000))"
		let fakeData_data = fakeData_string.data(using: .utf8)!
		
		let json: NSMutableDictionary = [
			
			"date_deferredToDate": Array(fakeData_data),
		
			"date_base64": fakeData_data.base64EncodedString(),
		
			"date_custom": Array(fakeData_data)
		]
		let object = try TestStruct_dataStrategy.decode(from: json)
		
		assert(try object.toJSON() as NSDictionary != json)
		json["date_custom"] = Array(TestStruct_dataStrategy.customData)
		assert(try object.toJSON() as NSDictionary == json)
		
	}
}
