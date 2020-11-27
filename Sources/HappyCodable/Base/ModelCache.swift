//
//  ModelCache.swift
//  Pods
//
//  Created by 庄黛淳华 on 2020/9/24.
//

import Foundation

/// 保存 HappyCodable 缓存的模型
@usableFromInline
struct ModelCache {
	let modelType: Any.Type
	/// 默认模型的JSON
	var defaltDecodeJSON: [String: Any]!
	/// 默认模型的JSON
	var decodeAttributes = [String: Any]()
}
protocol AlterCodingKey {
	var alterKeys: [String] { get }
}
protocol UncodingIdentifier {
	
}
extension ModelCache {
	struct AlterCodingKeys<T>: AlterCodingKey {
		let alterKeys: [String]
		let defaultValue: (() -> T)?
	}
	struct DateStrategy {
		typealias Encoding = Foundation.JSONEncoder.DateEncodingStrategy
		typealias Decoding = Foundation.JSONDecoder.DateDecodingStrategy
		let encode: Encoding
		let decode: Decoding
		let defaultValue: (() -> Date)?
	}
	struct DataStrategy {
		typealias Encoding = Foundation.JSONEncoder.DataEncodingStrategy
		typealias Decoding = Foundation.JSONDecoder.DataDecodingStrategy
		let encode: Encoding
		let decode: Decoding
		let defaultValue: (() -> Data)?
	}
	struct NonConformingFloatStrategy<Float: BinaryFloatingPoint> {
		typealias Encoding = Foundation.JSONEncoder.NonConformingFloatEncodingStrategy
		typealias Decoding = Foundation.JSONDecoder.NonConformingFloatDecodingStrategy
		let encode: Encoding
		let decode: Decoding
		let defaultValue: (() -> Float)?
	}
	
	struct Uncoding<T>: UncodingIdentifier {
		let defaultValue: () -> T
	}
	
	struct DynamicDefault<T> {
		let defaultValue: (() -> T)?
	}
}
