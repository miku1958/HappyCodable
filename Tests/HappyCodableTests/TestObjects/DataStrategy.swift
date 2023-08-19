//
//  DataStrategy.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

@HappyCodable
struct TestStruct_dataStrategy: HappyCodable, Equatable {
	@DataStrategy(decode: .deferredToData, encode: .deferredToData)
	var data_deferredToData: Data = Self.defaultData

	@DataStrategy(decode: .base64, encode: .base64)
	var data_base64: Data = Self.defaultData

	@DataStrategy(decode: .custom {
		_ = try $0.singleValueContainer().decode(Data.self)
		return Self.customData
	}, encode: .custom { _, encoder in
		try Self.customData.encode(to: encoder)
	})
	var data_custom: Data = Self.defaultData
	// swiftlint:disable force_unwrapping
	static let customData = "\(Int.random(in: 0...1000))".data(using: .utf8)!
	static let defaultData = "\(Int.random(in: 0...1000))".data(using: .utf8)!
	// swiftlint:enable force_unwrapping

	init(data_deferredToData: Data, data_base64: Data, data_custom: Data) {
		self.data_deferredToData = data_deferredToData
		self.data_base64 = data_base64
		self.data_custom = data_custom
	}
}
