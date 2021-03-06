//
//  DateDecodingStrategyTest.swift
//  CommonTests
//
//  Created by 庄黛淳华 on 2020/9/25.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import XCTest
@testable import HappyCodable
#if canImport(Demo)
@testable import Demo
#endif

class DateCodingStrategyTest: XCTestCase {
	func test() {
		let fakeData_date = Date(timeIntervalSince1970: TimeInterval.random(in: 100000000...10000000000))
		let fakeData_dateJSON = try! String(data: Foundation.JSONEncoder().encode(fakeData_date), encoding: .utf8)!
		let iso8601formatter = ISO8601DateFormatter()
		iso8601formatter.formatOptions = .withInternetDateTime
		
		let json: NSDictionary = [
			"date_deferredToDate": fakeData_dateJSON,
			
			"date_secondsSince1970": fakeData_date.timeIntervalSince1970,
			
			"date_millisecondsSince1970": fakeData_date.timeIntervalSince1970 * 1000,
			
			"date_iso8601": iso8601formatter.string(from: fakeData_date),
			
			"date_formatted": TestStruct_dateStrategy.dateFormater.string(from: fakeData_date),
			
			"date_custom": fakeData_dateJSON
		]
		let object = try! TestStruct_dateStrategy.decode(from: json)
		
		assert(object.date_deferredToDate == fakeData_date)
		assert(object.date_secondsSince1970 == fakeData_date)
		assert(object.date_millisecondsSince1970 == fakeData_date)
		assert("\(object.date_iso8601)" == "\(fakeData_date)") // 格式后会丢掉毫秒的信息
		assert("\(object.date_formatted)" == "\(fakeData_date)") // 格式后会丢掉毫秒的信息
		assert(object.date_custom == TestStruct_dateStrategy.customDate)
	}
	func testNSNull() {
		let json: NSDictionary = [
			"date_deferredToDate": NSNull(),
			
			"date_secondsSince1970": NSNull(),
			
			"date_millisecondsSince1970": NSNull(),
			
			"date_iso8601": NSNull(),
			
			"date_formatted": NSNull(),
			
			"date_custom": NSNull()
		]
		let object = try! TestStruct_dateStrategy.decode(from: json)
		
		assert(object.date_deferredToDate == TestStruct_dateStrategy.defaultDate)
		assert(object.date_secondsSince1970 == TestStruct_dateStrategy.defaultDate)
		assert(object.date_millisecondsSince1970 == TestStruct_dateStrategy.defaultDate)
		assert("\(object.date_iso8601)" == "\(TestStruct_dateStrategy.defaultDate)") // 格式后会丢掉毫秒的信息
		assert("\(object.date_formatted)" == "\(TestStruct_dateStrategy.defaultDate)") // 格式后会丢掉毫秒的信息
		assert(object.date_custom == TestStruct_dateStrategy.defaultDate)
	}
}

extension Date {
	// 由于单双精度切换的问题, 有时候6位小数后会有变化所以这里至今过滤掉了
	static func ==(lhs: Date, rhs: Date) -> Bool {
		return Int(lhs.timeIntervalSince1970 * 100000) == Int(rhs.timeIntervalSince1970 * 100000)
	}
}
