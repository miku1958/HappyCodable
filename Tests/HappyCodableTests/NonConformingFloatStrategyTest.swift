//
//  NonConformingFloatDecodingStrategyTest.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/9/26.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
#if canImport(Demo)
@testable import Demo
#endif

class NonConformingFloatDecodingStrategyTest: XCTestCase {

	func test() {
		let fakeData_Double = Double(Int.random(in: 0...10000))
		var json: NSDictionary = [
			"doubleConvertFromString": fakeData_Double,
			
			"doubleThrow": fakeData_Double
		]
		
		assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == json)
		
		do {
			let object = try TestStruct_nonConformingFloatStrategy.decode(from: [:])
			assert(object.doubleThrow == TestStruct_nonConformingFloatStrategy.Data.fakeData_double)
			assert(object.doubleConvertFromString == TestStruct_nonConformingFloatStrategy.Data.fakeData_double)
		} catch {
			assertionFailure()
		}
		
		json = [
			"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.nan
		]
		// Double.nan 是不能对比的
		assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).doubleConvertFromString.isNaN)
		assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == [
			"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.nan,
			"doubleThrow": TestStruct_nonConformingFloatStrategy.Data.fakeData_double
		])
		json = [
			"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.positiveInfinity
		]
		
		assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).doubleConvertFromString == .infinity)
		assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == [
			"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.positiveInfinity,
			"doubleThrow": TestStruct_nonConformingFloatStrategy.Data.fakeData_double
		])
		
		json = [
			"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.negativeInfinity
		]
		assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).doubleConvertFromString == -.infinity)
		assert(try TestStruct_nonConformingFloatStrategy.decode(from: json).toJSON() as NSDictionary == [
			"doubleConvertFromString": TestStruct_nonConformingFloatStrategy.Data.negativeInfinity,
			"doubleThrow": TestStruct_nonConformingFloatStrategy.Data.fakeData_double
			])
		
	}
}
