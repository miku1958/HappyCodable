//
//  CodingKeysExistTests.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest

class CodingKeysExistTests: XCTestCase {
	func test() {
		let fakeData_int = Int.random(in: 0...1000)
		let fakeData_bool = Bool.random()
		let fakeData_string = "\(fakeData_int)\(fakeData_bool)"
		let object = TestStruct_codingKeysExist(int: fakeData_int, string: fakeData_string, bool: fakeData_bool)
		assert(try object.toJSON() as NSDictionary == [
			"int_alter": fakeData_int,
			"string_alter": fakeData_string,
			"bool": fakeData_bool
		])
		assert(try TestStruct_codingKeysExist.decode(from: try object.toJSON()) == object)
	}
}
