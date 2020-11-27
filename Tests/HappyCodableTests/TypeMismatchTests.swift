//
//  TypeMismatchTests.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/8/1.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
#if canImport(Demo)
@testable import Demo
#endif

class TypeMismatchTests: XCTestCase {
	func testBaseDataType() {
		let fakeData_int = Int.random(in: 0...127)
		let fakeData_double: Double = Double(fakeData_int)/100
		let fakeData_String: String = NSNumber(value: fakeData_double).stringValue
		
		
		let fakeData_bool = Bool.random()

		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"Bool_2": fakeData_bool ? 1: 0,
		]).Bool == fakeData_bool)
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"Bool_2": fakeData_bool ? "1": "0",
		]).Bool == fakeData_bool)
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"Bool_2": fakeData_bool ? "true": "false",
		]).Bool == fakeData_bool)
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"String_2": fakeData_int,
		]).String == "\(fakeData_int)")
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"String_2": fakeData_double,
		]).String == fakeData_String)
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"String_2": fakeData_bool,
		]).String == "\(fakeData_bool)")
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"String_2": UInt64.max,
		]).String == "\(UInt64.max)")
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"Double_2": fakeData_String,
		]).Double == fakeData_double)
		
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"Int_2": "\(fakeData_int)",
		]).Int == fakeData_int)
		
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"UInt_2": "\(fakeData_int)",
		]).UInt == fakeData_int)
	}
    func testBaseTypeWithoutPropertyWrapper() {
        assert(try TestStruct_TypeMismatch.decode(from: [
            "Int": Date().description,
        ]).Int == TestStruct_TypeMismatch().Int)
    }
}
