//
//  TypeMismatchTests.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/8/1.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
@testable import HappyCodableDemo

class TypeMismatchTests: XCTestCase {
	func testBaseDataType() throws {
		let fakeData_int = Int.random(in: 0...127)
		let fakeData_double: Double = Double(fakeData_int)/10 + 0.1 // 防止出现 4.0 这种情况被当初Int解析
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
		]).String == "\(fakeData_double)")
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"String_2": fakeData_bool,
		]).String == "\(fakeData_bool)")
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"String_2": UInt64.max,
		]).String == "\(UInt64.max)")
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"Double_2": "\(fakeData_double)",
		]).Double == fakeData_double)
		
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"Int_2": "\(fakeData_int)",
		]).Int == fakeData_int)
		
		assert(try TestStruct_ForKeyedDecodingContainer.decode(from: [
			"UInt_2": "\(fakeData_int)",
		]).UInt == fakeData_int)
	}
	func testEnum() throws {
		let decoder = JSONDecoder()
		assert(try decoder.decode(TestEnumInt.self, from: "\"\(TestEnumInt.one.rawValue)\"".data(using: .utf8)!) == .one)
		assert(try decoder.decode(TestEnumDouble.self, from: "\"\(TestEnumDouble.pi.rawValue)\"".data(using: .utf8)!) == .pi)
		assert(try decoder.decode(TestEnumString.self, from: "123".data(using: .utf8)!) == .int)
		assert(try decoder.decode(TestEnumString.self, from: "3.14".data(using: .utf8)!) == .double)
		assert(try decoder.decode(TestEnumString.self, from: "true".data(using: .utf8)!) == .true)
	}
}
