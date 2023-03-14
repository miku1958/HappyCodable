//
//  KeyedDecodingContainerTests.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest

class KeyedDecodingContainerTests: XCTestCase {
	func test() throws {
		// 到127是为了防止Int8转不了
		let fakeData_int = Int.random(in: 0...127)
		let fakeData_bool = Bool.random()
		let json: NSDictionary = [
			"Bool_2": fakeData_bool,
			"String_2": "\(fakeData_int)\(fakeData_bool)",
			"Double_2": fakeData_int,
			"Float_2": fakeData_int,
			"Int_2": fakeData_int,
			"Int8_2": fakeData_int,
			"Int16_2": fakeData_int,
			"Int32_2": fakeData_int,
			"Int64_2": fakeData_int,
			"UInt_2": fakeData_int,
			"UInt8_2": fakeData_int,
			"UInt16_2": fakeData_int,
			"UInt32_2": fakeData_int,
			"UInt64_2": fakeData_int,

			"Bool_optional_2": fakeData_bool,
			"String_optional_2": "\(fakeData_int)\(fakeData_bool)",
			"Double_optional_2": fakeData_int,
			"Float_optional_2": fakeData_int,
			"Int_optional_2": fakeData_int,
			"Int8_optional_2": fakeData_int,
			"Int16_optional_2": fakeData_int,
			"Int32_optional_2": fakeData_int,
			"Int64_optional_2": fakeData_int,
			"UInt_optional_2": fakeData_int,
			"UInt8_optional_2": fakeData_int,
			"UInt16_optional_2": fakeData_int,
			"UInt32_optional_2": fakeData_int,
			"UInt64_optional_2": fakeData_int,
		]
		let object = try TestStruct_ForKeyedDecodingContainer.decode(from: json)
		assert(object.Bool == fakeData_bool)
		assert(object.String == "\(fakeData_int)\(fakeData_bool)")
		assert(object.Double == .init(fakeData_int))
		assert(object.Float == .init(fakeData_int))
		assert(object.Int == .init(fakeData_int))
		assert(object.Int8 == .init(fakeData_int))
		assert(object.Int16 == .init(fakeData_int))
		assert(object.Int32 == .init(fakeData_int))
		assert(object.Int64 == .init(fakeData_int))
		assert(object.UInt == .init(fakeData_int))
		assert(object.UInt8 == .init(fakeData_int))
		assert(object.UInt16 == .init(fakeData_int))
		assert(object.UInt32 == .init(fakeData_int))
		assert(object.UInt64 == .init(fakeData_int))

		assert(object.Bool_optional == fakeData_bool)
		assert(object.String_optional == "\(fakeData_int)\(fakeData_bool)")
		assert(object.Double_optional == .init(fakeData_int))
		assert(object.Float_optional == .init(fakeData_int))
		assert(object.Int_optional == .init(fakeData_int))
		assert(object.Int8_optional == .init(fakeData_int))
		assert(object.Int16_optional == .init(fakeData_int))
		assert(object.Int32_optional == .init(fakeData_int))
		assert(object.Int64_optional == .init(fakeData_int))
		assert(object.UInt_optional == .init(fakeData_int))
		assert(object.UInt8_optional == .init(fakeData_int))
		assert(object.UInt16_optional == .init(fakeData_int))
		assert(object.UInt32_optional == .init(fakeData_int))
		assert(object.UInt64_optional == .init(fakeData_int))
	}
}
