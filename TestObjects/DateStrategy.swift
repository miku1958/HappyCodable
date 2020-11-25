//
//  DateCodingStrategy.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/9/25.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct TestStruct_dateStrategy: HappyCodable, Equatable {
	@Happy.dateStrategy(decode: .deferredToDate, encode: .deferredToDate)
	var date_deferredToDate: Date = Self.defaultDate
	
	@Happy.dateStrategy(decode: .secondsSince1970, encode: .secondsSince1970)
	var date_secondsSince1970: Date = Self.defaultDate
	
	@Happy.dateStrategy(decode: .millisecondsSince1970, encode: .millisecondsSince1970)
	var date_millisecondsSince1970: Date = Self.defaultDate
	
	@Happy.dateStrategy(decode: .iso8601, encode: .iso8601)
	var date_iso8601: Date = Self.defaultDate
	
	@Happy.dateStrategy(decode: .formatted(Self.dateFormater), encode: .formatted(Self.dateFormater))
	var date_formatted: Date = Self.defaultDate
	
	@Happy.dateStrategy(decode: .custom({
		_ = try $0.singleValueContainer().decode(Date.self)
		return Self.customDate
	}), encode: .custom({ _, encoder in
		try Self.customDate.encode(to: encoder)
	})) var date_custom: Date = Self.defaultDate
	
	static var dateFormater: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
		return formatter
	}()
	
	static let customDate = Date()
	static let defaultDate = Date(timeIntervalSince1970: TimeInterval.random(in: 0...100000000000))
}

