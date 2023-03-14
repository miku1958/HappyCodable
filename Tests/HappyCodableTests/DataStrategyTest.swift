//
//  DataStrategyTest.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest

class DataCodingStrategyTest: XCTestCase {
	func test() throws {
		let fakeData_string = "\(Int.random(in: 0...1000000000))"
		// swiftlint:disable force_unwrapping
		let fakeData_data = fakeData_string.data(using: .utf8)!
		// swiftlint:enable force_unwrapping

		let json: NSMutableDictionary = [

			"data_deferredToData": Array(fakeData_data),

			"data_base64": fakeData_data.base64EncodedString(),

			"data_custom": Array(fakeData_data)
		]
		let object = try TestStruct_dataStrategy.decode(from: json)

		assert(try object.toJSON() as NSDictionary != json)
		json["data_custom"] = Array(TestStruct_dataStrategy.customData)
		assert(try object.toJSON() as NSDictionary == json)
	}
	func testNull() throws {
		let json: NSMutableDictionary = [

			"data_deferredToDate": NSNull(),

			"data_base64": NSNull(),

			"data_custom": NSNull()
		]
		let object = try TestStruct_dataStrategy.decode(from: json)

		assert(try object.toJSON() as NSDictionary != json)

		assert(object.data_deferredToData == TestStruct_dataStrategy.defaultData)
		assert(object.data_base64 == TestStruct_dataStrategy.defaultData)
		assert(object.data_custom == TestStruct_dataStrategy.defaultData)
	}
}
