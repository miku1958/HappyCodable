//
//  ArrayNullTest.swift
//  
//
//  Created by 庄黛淳华 on 2023/2/23.
//

import Foundation

import XCTest
@testable import HappyCodable
#if canImport(Demo)
@testable import Demo
#endif


class ArrayNullTest: XCTestCase {
	func test() throws {
		let json =
"""
{
	"data": ["a", "b", null]
}
"""
		final class HappyField: HappyCodable {
			@Happy.elementNullable
			var data: [String] = []
		}
		XCTAssertEqual(try HappyField.decode(from: json).data, ["a", "b"])
	}
}
