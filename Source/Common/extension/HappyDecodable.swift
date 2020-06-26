//
//  HappyDecodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/18.
//

import Foundation

public enum HappyDecodableError: String, Swift.Error {
	case inputEmpty
	case invalidDesignatedPath
	case TypeError
}

private func dictionary<R>(from dict: [String: Any], designatedPath: String?) throws -> R {
	var result: Any = dict
	if var designateds = designatedPath?.split(separator: ".") {
		while !designateds.isEmpty {
			let key = designateds.removeFirst()
			guard let next = (result as? [String: Any])?[String(key)]  else {
				throw HappyDecodableError.invalidDesignatedPath
			}
			result = next
		}
	}
	guard let value = result as? R  else {
		throw HappyDecodableError.TypeError
	}
	return value
}

public extension HappyCodableSerialization where Self: Decodable {
	/// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
	/// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
	@inline(__always)
	static func decode(from dict: NSDictionary?, designatedPath: String? = nil) throws -> Self {
		return try decode(from: dict as? [String: Any], designatedPath: designatedPath)
	}
	
	/// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to a Model
	/// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
	@inline(__always)
	static func decode(from json: String?, designatedPath: String? = nil) throws -> Self {
		guard let data = json?.data(using: .utf8) else {
			throw HappyDecodableError.inputEmpty
		}
		let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		
		return try decode(from: dict, designatedPath: designatedPath)
	}
	
	/// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
	/// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
	@inline(__always)
	static func decode(from dict: [String: Any]?, designatedPath: String? = nil) throws -> Self {
		guard var dict = dict else {
			throw HappyDecodableError.inputEmpty
		}
		dict = try dictionary(from: dict, designatedPath: designatedPath)
		
		let data = try JSONSerialization.data(withJSONObject: dict, options: [])
		return try JSONDecoder().decode(Self.self, from: data)
	}
}
public extension Array where Element: HappyCodableSerialization & Decodable {
	
	/// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
	/// this method converts it to a Models array
	@inline(__always)
	static func decode(from json: String?, designatedPath: String? = nil) throws -> [Element] {
		guard
			let data = json?.data(using: .utf8),
			var dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		else {
			throw HappyDecodableError.inputEmpty
		}
		let arr: [[String: Any]] = try dictionary(from: dict, designatedPath: designatedPath)
		
		return try decode(from: arr)
	}
	
	/// deserialize model array from NSArray
	@inline(__always)
	static func decode(from array: NSArray?) throws -> [Element] {
		guard let arr = array as? [[String: Any]] else {
			throw HappyDecodableError.inputEmpty
		}
		return try decode(from: arr)
	}
	
	/// deserialize model array from array
	@inline(__always)
	static func decode(from array: [Any]?) throws -> [Element] {
		guard let arr = array as? [[String: Any]] else {
			throw HappyDecodableError.inputEmpty
		}
		return try decode(from: arr)
	}
	
	/// deserialize model array from array
	@inline(__always)
	static func decode(from array: [[String: Any]]?) throws -> [Element] {
		guard let array = array else {
			throw HappyDecodableError.inputEmpty
		}
		return try decode(from: array)
	}
	
	/// deserialize model array from array
	@inline(__always)
	static func decode(from array: [[String: Any]]) throws -> [Element] {
		return try array.compactMap {
			try Element.decode(from: $0)
		}
	}
}
