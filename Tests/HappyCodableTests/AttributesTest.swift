//
//  AttributesTest.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest

func assert(_ condition: @autoclosure () throws -> Bool) {
	do {
		let result = try condition()
		XCTAssert(result)
	} catch {
		XCTFail("\(error)")
	}
}

class AttributesTest: XCTestCase {
	func test() {
		// MARK: - optional
		let fakeData_optional = Int.random(in: 0..<10000)

		// MARK: - codingKeys
		let fakeData_codingKeys = Int.random(in: 0..<10000)

		assert(try TestStruct_withAttribute.decode(from: ["codingKey1": fakeData_codingKeys]).codingKeys == fakeData_codingKeys)
		assert(try TestStruct_withAttribute.decode(from: ["codingKey2": fakeData_codingKeys]).codingKeys == fakeData_codingKeys)
		// emoji test, SourceKittenFramework does not use Unicode to parser swift files
		assert(try TestStruct_withAttribute.decode(from: ["🍉": fakeData_codingKeys]).codingKeys == fakeData_codingKeys)

		assert(try TestStruct_withAttribute.decode(from: ["codingKey": fakeData_codingKeys]).codingKeys != fakeData_codingKeys)
		assert(try TestStruct_withAttribute.decode(from: ["codingKey": fakeData_codingKeys]).codingKeys == TestStruct_withAttribute().codingKeys)

		// MARK: - uncoding
		let fakeData_uncoding = Int.random(in: 0..<10000)
		assert(try TestStruct_withAttribute.decode(from: ["uncoding": fakeData_uncoding]).codingKeys == TestStruct_withAttribute().uncoding)
		assert(try TestStruct_withAttribute.decode(from: ["uncoding": fakeData_uncoding]).codingKeys != fakeData_uncoding)

		// MARK: - encode
		let object = TestStruct_withAttribute(codingKeys: fakeData_codingKeys, optional_allow: fakeData_optional, optional_notAllow: fakeData_optional, uncoding: fakeData_uncoding)
		assert(try object.toJSON() as NSDictionary == [
			"codingKeys": fakeData_codingKeys,
			"optional_allow": fakeData_optional,
			"optional_notAllow": fakeData_optional
		])
	}
}
