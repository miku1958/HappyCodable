//
//  CommonTests.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/7/31.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
@testable import HappyCodableDemo

func assert(_ condition: @autoclosure () throws -> Bool) {
	do {
		let result = try condition()
		Swift.assert(result)
	} catch {
		Swift.assertionFailure()
	}
}

class CommonTests: XCTestCase {
	// 空的类型decode会直接报错所以不测了
	// Top-level TestClass_empty did not encode any values.
	func testClass() throws {
		let fakeData_object_int = Int.random(in: (0 ... 10000))
		
		let fakeData_object_class_int = Int.random(in: (0 ... 10000))
		let fakeData_object_class_string = "\(Double.random(in: (0.0 ... 10000.0)))"
		
		let fakeData_object_struct_int = Int.random(in: (0 ... 10000))
		let fakeData_object_struct_string = "\(Double.random(in: (0.0 ... 10000.0)))"
		
		let object = TestClass_notEmpty()
		
		object.int = fakeData_object_int
		
		object.object.int = fakeData_object_class_int
		object.object.string = fakeData_object_class_string
		
		object.objectNil = .init()
		object.objectNil?.int = fakeData_object_struct_int
		object.objectNil?.string = fakeData_object_struct_string
		
		let json = try object.toJSON() as NSDictionary
		let jsonString = try object.toJSONString(prettyPrint: false)
		
		struct Package<Object>: Codable where Object: Codable {
			let data: Package
			struct Package: Codable {
				let object: Object
			}
		}
		
		let encoder = JSONEncoder()
		assert(try TestClass_notEmpty.decode(from: try encoder.encode(Package(data: .init(object: object))), designatedPath: "data.object").toJSONString() == jsonString)
		
		assert(try (try [TestClass_notEmpty].decode(from: try [object].toJSONString()))[0].toJSONString() == jsonString)
		assert(try (try [TestClass_notEmpty].decode(from: try [object].toJSON()))[0].toJSONString() == jsonString)
		assert(try (try [TestClass_notEmpty].decode(from: try encoder.encode(Package(data: .init(object: [object]))), designatedPath: "data.object"))[0].toJSONString() == jsonString)
		
		assert(json == [
			"int": fakeData_object_int,
			"object": [
				"int": fakeData_object_class_int,
				"string": fakeData_object_class_string
			],
			"objectNil": [
				"int": fakeData_object_struct_int,
				"string": fakeData_object_struct_string
			]
		])
		assert(jsonString == "{\"int\":\(fakeData_object_int),\"object\":{\"int\":\(fakeData_object_class_int),\"string\":\"\(fakeData_object_class_string)\"},\"objectNil\":{\"int\":\(fakeData_object_struct_int),\"string\":\"\(fakeData_object_struct_string)\"}}")
		assert(try object.toJSONString(prettyPrint: true) == "{\n  \"int\" : \(fakeData_object_int),\n  \"object\" : {\n    \"int\" : \(fakeData_object_class_int),\n    \"string\" : \"\(fakeData_object_class_string)\"\n  },\n  \"objectNil\" : {\n    \"int\" : \(fakeData_object_struct_int),\n    \"string\" : \"\(fakeData_object_struct_string)\"\n  }\n}")
		let fromJSON = try TestClass_notEmpty.decode(from: json)
		let fromString = try TestClass_notEmpty.decode(from: jsonString)
		
		assert(fromJSON.int == fakeData_object_int)
		assert(fromJSON.object.int == fakeData_object_class_int)
		assert(fromJSON.objectNil?.int == fakeData_object_struct_int)
		
		assert(fromJSON.object.string == fakeData_object_class_string)
		assert(fromJSON.objectNil?.string == fakeData_object_struct_string)
		
		assert(fromString.int == fakeData_object_int)
		assert(fromString.object.int == fakeData_object_class_int)
		assert(fromString.objectNil?.int == fakeData_object_struct_int)
		
		assert(fromString.object.string == fakeData_object_class_string)
		assert(fromString.objectNil?.string == fakeData_object_struct_string)
	}

	func testStruct() throws {
		let fakeData_object_int = Int.random(in: (0 ... 10000))
		
		let fakeData_object_class_int = Int.random(in: (0 ... 10000))
		let fakeData_object_class_string = "\(Double.random(in: (0.0 ... 10000.0)))"
		
		let fakeData_object_struct_int = Int.random(in: (0 ... 10000))
		let fakeData_object_struct_string = "\(Double.random(in: (0.0 ... 10000.0)))"
		
		var object = TestStruct_notEmpty()
		
		object.int = fakeData_object_int
		
		object.object.int = fakeData_object_class_int
		object.object.string = fakeData_object_class_string
		
		object.objectNil = .init()
		object.objectNil?.int = fakeData_object_struct_int
		object.objectNil?.string = fakeData_object_struct_string
		
		let json = try object.toJSON() as NSDictionary
		let jsonString = try object.toJSONString(prettyPrint: false)
		
		assert(json == [
			"int": fakeData_object_int,
			"object": [
				"int": fakeData_object_class_int,
				"string": fakeData_object_class_string
			],
			"objectNil": [
				"int": fakeData_object_struct_int,
				"string": fakeData_object_struct_string
			]
		])
		assert(jsonString == "{\"int\":\(fakeData_object_int),\"object\":{\"int\":\(fakeData_object_class_int),\"string\":\"\(fakeData_object_class_string)\"},\"objectNil\":{\"int\":\(fakeData_object_struct_int),\"string\":\"\(fakeData_object_struct_string)\"}}")
		assert(try object.toJSONString(prettyPrint: true) == "{\n  \"int\" : \(fakeData_object_int),\n  \"object\" : {\n    \"int\" : \(fakeData_object_class_int),\n    \"string\" : \"\(fakeData_object_class_string)\"\n  },\n  \"objectNil\" : {\n    \"int\" : \(fakeData_object_struct_int),\n    \"string\" : \"\(fakeData_object_struct_string)\"\n  }\n}")
		let fromJSON = try TestStruct_notEmpty.decode(from: json)
		let fromString = try TestStruct_notEmpty.decode(from: jsonString)
		
		assert(fromJSON.int == fakeData_object_int)
		assert(fromJSON.object.int == fakeData_object_class_int)
		assert(fromJSON.objectNil?.int == fakeData_object_struct_int)
		
		assert(fromJSON.object.string == fakeData_object_class_string)
		assert(fromJSON.objectNil?.string == fakeData_object_struct_string)
		
		assert(fromString.int == fakeData_object_int)
		assert(fromString.object.int == fakeData_object_class_int)
		assert(fromString.objectNil?.int == fakeData_object_struct_int)
		
		assert(fromString.object.string == fakeData_object_class_string)
		assert(fromString.objectNil?.string == fakeData_object_struct_string)
	}
	
	func testEnunRawRepresentable() throws {
		let em = TestEnum.allCases.randomElement()!
		let json = try em.toJSONString()
		assert(json == "\"\(em.rawValue)\"")
		assert(try TestEnum.decode(from: json) == em)
		let emRaw =  try TestEnumRawRepresentable.decode(from: "\"\(em.rawValue)\"")
		assert(emRaw == TestEnumRawRepresentable(rawValue: em))
		assert(try emRaw.toJSONString() == json)
	}
	
	func testEnunComplex() throws {
		assert(try TestEnumComplex.decode(from: try TestEnumComplex.value.toJSON()) == .value)
		let fakeData_int = Int.random(in: 0..<1000)
		let fakeData_string = "\(Double.random(in: 0..<1000))"
		let function = TestEnumComplex.function(int: fakeData_int, string: fakeData_string)
		let json = try function.toJSON() as NSDictionary
		
		assert(json ==  [
			".function(int:string:)": [
				"int": "\(fakeData_int)",
				"string": "\"\(fakeData_string)\""
			]
		])
		assert(try TestEnumComplex.decode(from: json) == function)
	}
}
