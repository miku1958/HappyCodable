//
//  UncodingTest.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest

// swiftlint:disable empty_collection_literal

class UncodingTest: XCTestCase {
	func test() throws {
		let fakeData_Int = Int.random(in: 0...1000000000)
		let json: NSDictionary = [
			"uncoing": fakeData_Int,
			"uncoingOptional": [
				"int": fakeData_Int
			]
		]
		let object = try TestStruct_uncoding.decode(from: json)
		assert(object.uncoingOptional == nil)

		assert(object.uncoing == TestStruct_uncoding().uncoing)

		assert((try object.toJSON() as NSDictionary) == [:])
	}
}

// swiftlint:enable empty_collection_literal
