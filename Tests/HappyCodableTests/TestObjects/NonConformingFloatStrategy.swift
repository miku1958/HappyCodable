//
//  FloatStrategy.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

@HappyCodable
struct TestStruct_floatStrategy: HappyCodable {
	@FloatStrategy(
		decode: .convertFromString(positiveInfinity: Data.positiveInfinity, negativeInfinity: Data.negativeInfinity, nan: Data.nan),
		encode: .convertToString(positiveInfinity: Data.positiveInfinity, negativeInfinity: Data.negativeInfinity, nan: Data.nan)
	) var doubleConvertFromString: Double = Data.fakeData_double

	@FloatStrategy(decode: .throw, encode: .throw)
	var doubleThrow: Double = Data.fakeData_double

	enum Data {
		static let fakeData_double = Double(Int.random(in: 0...1000000))
		static let positiveInfinity = "positiveInfinity\(Int.random(in: 0...100))"
		static let negativeInfinity = "positiveInfinity\(Int.random(in: 0...100))"
		static let nan = "positiveInfinity\(Int.random(in: 0...100))"
	}

	init(doubleConvertFromString: Double, doubleThrow: Double) {
		self.doubleConvertFromString = doubleConvertFromString
		self.doubleThrow = doubleThrow
	}
}
