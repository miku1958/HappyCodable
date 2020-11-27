//
// Decodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/18.
//

import Foundation

public enum DecodeError: String, Swift.Error {
	case inputEmpty
	case invalidDesignatedPath
	case TypeError
	case unsupportedDecoder
}

private func dictionary<R>(from dict: [String: Any], designatedPath: String?) throws -> R {
	var result: Any = dict
	if var designateds = designatedPath?.split(separator: ".") {
		while !designateds.isEmpty {
			let key = designateds.removeFirst()
			guard let next = (result as? [String: Any])?[String(key)]  else {
				throw DecodeError.invalidDesignatedPath
			}
			result = next
		}
	}
	guard let value = result as? R  else {
		throw DecodeError.TypeError
	}
	return value
}

public extension HappyCodable {
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
			throw DecodeError.inputEmpty
		}
		return try decode(from: data, designatedPath: designatedPath)
	}
	
	/// Finds the internal JSON field in `data` as the `designatedPath` specified, and converts it to a Model
	/// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
	@inline(__always)
	static func decode(from data: Foundation.Data, designatedPath: String? = nil) throws -> Self {
		do {
			let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			return try decode(from: dict, designatedPath: designatedPath)
		} catch {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: error))
		}
	}
	
	/// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
	/// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
	@inline(__always)
	static func decode(from dict: [String: Any]?, designatedPath: String? = nil) throws -> Self {
		guard var dict = dict else {
			throw DecodeError.inputEmpty
		}
		dict = try dictionary(from: dict, designatedPath: designatedPath)
		
		return try _decode(Self.self, from: dict)
	}
}
public extension Array where Element: HappyCodable {
	
	/// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
	/// this method converts it to a Models array
	@inline(__always)
	static func decode(from json: String?, designatedPath: String? = nil) throws -> [Element] {
		try decode(from: json?.data(using: .utf8))
	}
	
	/// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
	/// this method converts it to a Models array
	@inline(__always)
	static func decode(from data: Foundation.Data?, designatedPath: String? = nil) throws -> [Element] {
		guard
			let data = data
		else {
			throw DecodeError.inputEmpty
		}
		
		let json = try JSONSerialization.jsonObject(with: data, options: [])
		if let dicts = json as? [[String: Any]] {
			return try decode(from: dicts)
		} else if let dict = json as? [String: Any] {
			let arr: [[String: Any]] = try dictionary(from: dict, designatedPath: designatedPath)
			return try decode(from: arr)
		} else {
			throw DecodeError.TypeError
		}
	}
	
	/// deserialize model array from NSArray
	@inline(__always)
	static func decode(from array: NSArray?) throws -> [Element] {
		return try decode(from: array as? [[String: Any]])
	}
	
	/// deserialize model array from array
	@inline(__always)
	static func decode(from array: [Any]?) throws -> [Element] {
		return try decode(from: array as? [[String: Any]])
	}
	
	/// deserialize model array from array
	@inline(__always)
	static func decode(from array: [[String: Any]]?) throws -> [Element] {
		guard let array = array else {
			throw DecodeError.inputEmpty
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
