//
//  DateCodingStrategy.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/9/25.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct TestStruct_dataStrategy: HappyCodable, Equatable {
	@Happy.dataStrategy(decode: .deferredToData, encode: .deferredToData)
	var date_deferredToDate: Data = Data()

	@Happy.dataStrategy(decode: .base64, encode: .base64)
	var date_base64: Data = Data()
	
	@Happy.dataStrategy(decode: .custom({ _ in
		Self.customData
	}), encode: .custom({ data, encoder in
		try Self.customData.encode(to: encoder)
	}))
	var date_custom: Data = Data()
	
	static let customData = "\(Int.random(in: 0...1000))".data(using: .utf8)!
}
