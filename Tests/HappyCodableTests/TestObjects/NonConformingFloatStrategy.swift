//
//  NonConformingFloatStrategy.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/9/26.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct TestStruct_nonConformingFloatStrategy: HappyCodable {
	@Happy.nonConformingFloatStrategy(
		decode: .convertFromString(positiveInfinity: Data.positiveInfinity, negativeInfinity: Data.negativeInfinity, nan: Data.nan),
		encode: .convertToString(positiveInfinity: Data.positiveInfinity, negativeInfinity: Data.negativeInfinity, nan: Data.nan)
	) var doubleConvertFromString: Double = Data.fakeData_double
	
	@Happy.nonConformingFloatStrategy(decode: .throw,encode: .throw)
	var doubleThrow: Double = Data.fakeData_double
	
	struct Data {
		static let fakeData_double = Double(Int.random(in: 0...1000000))
		static let positiveInfinity = "positiveInfinity\(Int.random(in: 0...100))"
		static let negativeInfinity = "positiveInfinity\(Int.random(in: 0...100))"
		static let nan = "positiveInfinity\(Int.random(in: 0...100))"
	}
}
