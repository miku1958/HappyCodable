//
//  DynamicDefaultTest.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest
// swiftlint:disable identical_operands
class DynamicDefaultTest: XCTestCase {

	func test() {
		let fakeData_Int = Int.random(in: 0...1000000000)
		let json: NSDictionary = [
			"intDynamic": fakeData_Int,
			"intStatic": fakeData_Int
		]

		assert(try TestStruct_dynamicDefault.decode(from: json).toJSON() as NSDictionary == json)

		assert((try TestStruct_dynamicDefault.decode(from: [:])).intDynamic != (try TestStruct_dynamicDefault.decode(from: [:])).intDynamic)

		assert((try TestStruct_dynamicDefault.decode(from: [:])).intStatic == (try TestStruct_dynamicDefault.decode(from: [:])).intStatic)
	}
}
// swiftlint:enable identical_operands
