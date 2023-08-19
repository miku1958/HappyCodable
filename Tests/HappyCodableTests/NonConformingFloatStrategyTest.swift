//
//  FloatStrategyTest.swift
//  HappyCodable
//
//

@testable import HappyCodable
import XCTest

class NonConformingFloatDecodingStrategyTest: XCTestCase {

	func test() {
		let fakeData_Double = Double(Int.random(in: 0...10000))
		var json: NSDictionary = [
			"doubleConvertFromString": fakeData_Double,

			"doubleThrow": fakeData_Double
		]

		assert(try TestStruct_floatStrategy.decode(from: json).toJSON() as NSDictionary == json)

		do {
			let object = try TestStruct_floatStrategy.decode(from: [:])
			assert(object.doubleThrow == TestStruct_floatStrategy.Data.fakeData_double)
			assert(object.doubleConvertFromString == TestStruct_floatStrategy.Data.fakeData_double)
		} catch {
			assertionFailure()
		}

		json = [
			"doubleConvertFromString": TestStruct_floatStrategy.Data.nan
		]
		// Double.nan 是不能对比的
		assert(try TestStruct_floatStrategy.decode(from: json).doubleConvertFromString.isNaN)
		assert(try TestStruct_floatStrategy.decode(from: json).toJSON() as NSDictionary == [
			"doubleConvertFromString": TestStruct_floatStrategy.Data.nan,
			"doubleThrow": TestStruct_floatStrategy.Data.fakeData_double
		])
		json = [
			"doubleConvertFromString": TestStruct_floatStrategy.Data.positiveInfinity
		]

		assert(try TestStruct_floatStrategy.decode(from: json).doubleConvertFromString == .infinity)
		assert(try TestStruct_floatStrategy.decode(from: json).toJSON() as NSDictionary == [
			"doubleConvertFromString": TestStruct_floatStrategy.Data.positiveInfinity,
			"doubleThrow": TestStruct_floatStrategy.Data.fakeData_double
		])

		json = [
			"doubleConvertFromString": TestStruct_floatStrategy.Data.negativeInfinity
		]
		assert(try TestStruct_floatStrategy.decode(from: json).doubleConvertFromString == -.infinity)
		assert(try TestStruct_floatStrategy.decode(from: json).toJSON() as NSDictionary == [
			"doubleConvertFromString": TestStruct_floatStrategy.Data.negativeInfinity,
			"doubleThrow": TestStruct_floatStrategy.Data.fakeData_double
		])
	}
}
