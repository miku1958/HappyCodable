//
//  ArrayTest.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest

class ArrayTest: XCTestCase {
	@HappyCodable(disableWarnings: [.noInitializer])
	struct Model: HappyCodable {
		var value: Int = 0
	}

	func test() throws {
		let json: NSDictionary = [
			"target": [
				"value": 12
			],
			"code": 0
		]
		let jsonData = try JSONSerialization.data(withJSONObject: json)
		let jsonStr = String(data: jsonData, encoding: .utf8)

		assert(try Model.decode(from: json, designatedPath: "target").value == 12)
		assert(try Model.decode(from: json as? [String: Any], designatedPath: "target").value == 12)
		assert(try Model.decode(from: jsonData, designatedPath: "target").value == 12)
		assert(try Model.decode(from: jsonStr, designatedPath: "target").value == 12)
	}
}
