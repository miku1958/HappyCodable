//
//  ArrayTest.swift
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

class ArrayTest: XCTestCase {
	func test() throws {
		let json: NSDictionary = [
			"target": [
				"value": 12
			],
			"code": 0
		]
		let jsonData = try JSONSerialization.data(withJSONObject: json)
		let jsonStr = String(data: jsonData, encoding: .utf8)

		struct Model: HappyCodable {
			var value: Int = 0
		}


		assert(try Model.decode(from: json, designatedPath: "target").value == 12)
		assert(try Model.decode(from: json as? [String: Any], designatedPath: "target").value == 12)
		assert(try Model.decode(from: jsonData, designatedPath: "target").value == 12)
		assert(try Model.decode(from: jsonStr, designatedPath: "target").value == 12)
	}
}
