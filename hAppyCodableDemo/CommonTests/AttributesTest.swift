//
//  AttributesTest.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/7/31.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
@testable import HappyCodableDemo

class AttributesTest: XCTestCase {
    func test() throws {
		// MARK: - optional
		let fakeData_optional = Int.random(in: 0..<10000)
		TestStruct_withAttribute.allowHappyDecodableSkipMissing = false
		_ = try TestStruct_withAttribute.decode(from: ["optional_notAllow": fakeData_optional])
		do {
			_ = try TestStruct_withAttribute.decode(from: [:])
			XCTAssert(false)
		} catch {
			XCTAssert(true)
		}
		
		TestStruct_withAttribute.allowHappyDecodableSkipMissing = true
		_ = try TestStruct_withAttribute.decode(from: [:])
		
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
		assert(try TestStruct_withAttribute.decode(from: ["uncoding": fakeData_uncoding]).codingKeys ==  TestStruct_withAttribute().uncoding)
		assert(try TestStruct_withAttribute.decode(from: ["uncoding": fakeData_uncoding]).codingKeys !=  fakeData_uncoding)
		
		
		// MARK: - encode
		let object = TestStruct_withAttribute(codingKeys: fakeData_codingKeys, optional_allow: fakeData_optional, optional_notAllow: fakeData_optional, uncoding: fakeData_uncoding)
		assert(try object.toJSON() as NSDictionary == [
			"codingKey1": fakeData_codingKeys,
			"optional_allow": fakeData_optional,
			"optional_notAllow": fakeData_optional
		])
    }
}
