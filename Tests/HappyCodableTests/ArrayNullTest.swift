//
//  ArrayNullTest.swift
//  HappyCodable
//
//

import Foundation

@testable import HappyCodable
import XCTest

class ArrayNullTest: XCTestCase {
	@HappyCodable(disableWarnings: [.noInitializer])
	final class HappyField1: HappyCodable {
		@ElementNullable
		var data: [String] = []
	}
	func test() throws {
		let json =
"""
{
	"data": ["a", "b", null]
}
"""
		let data: [String] = try HappyField1.decode(from: json).data
		XCTAssertEqual(data, ["a", "b"])
	}

	@HappyCodable(disableWarnings: [.noInitializer])
	final class HappyField2: HappyCodable {
		@AlterCodingKeys("data1")
		@ElementNullable
		var data: [String] = []
	}
	func testWithAlter() throws {
		let json =
"""
{
 "data1": ["a", "b", null]
}
"""
		let data: [String] = try HappyField2.decode(from: json).data
		XCTAssertEqual(data, ["a", "b"])
	}
}
