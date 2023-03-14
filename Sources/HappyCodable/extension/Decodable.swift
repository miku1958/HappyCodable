//
//  Decodable.swift
//  HappyCodable
//
//

import Foundation

extension Decodable {
	/// Finds the internal JSON field in `data` as the `designatedPath` specified, and converts it to a Model
	/// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
	public static func decode(from datable: Datable?, designatedPath: String? = nil, allowsJSON5: Bool = false) throws -> Self {
		guard let datable else {
			throw DecodeError.inputEmpty
		}
		let data = try datable.data

		let decoder = JSONDecoder()
		decoder.dataDecodingStrategy = .deferredToData
		decoder.dateDecodingStrategy = .deferredToDate
		if #available(macOS 12.0, iOS 15.0, *) {
			decoder.allowsJSON5 = allowsJSON5
		}
		if let designatedPaths = designatedPath?.split(separator: ".") {
			AnyDecodableStorage.designatedPaths = designatedPaths.map(String.init)
		}
		let anyDecodable = try decoder.decode(AnyDecodable<Self>.self, from: data)

		return anyDecodable.getSingleValue()
	}
}

// MARK: - decode [[String: Any]]
extension Array where Element: Decodable {
	/// deserialize model array from NSArray
	@inlinable
	@inline(__always)
	public static func decode(from array: NSArray?, allowsJSON5: Bool = false) throws -> [Element] {
		return try decode(from: array as? [Any], allowsJSON5: allowsJSON5)
	}

	/// deserializae model array from array
	@inlinable
	@inline(__always)
	public static func decode(from array: [Any]?, allowsJSON5: Bool = false) throws -> [Element] {
		guard let array = array as? [[String: Any]] else {
			throw DecodeError.typeError
		}

		return try array.compactMap {
			try Element.decode(from: $0, allowsJSON5: allowsJSON5)
		}
	}
}
