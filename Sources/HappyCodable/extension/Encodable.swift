//
//  Encodable.swift
//  HappyCodable
//
//

import Foundation

public enum EncodeError: String, Swift.Error {
	case stringEncodingFail
	case toJSONTypeFail
}

extension HappyEncodable {
	func getEncoder() -> JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dataEncodingStrategy = .deferredToData
		encoder.dateEncodingStrategy = .deferredToDate
		return encoder
	}
	public func toJSON() throws -> [String: Any] {
		let encoder = getEncoder()
		let data = try encoder.encode(self)
		guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
			throw EncodeError.toJSONTypeFail
		}
		return object
	}

	public func toJSONString(prettyPrint: Bool = false) throws -> String {
		let encoder = getEncoder()
		if prettyPrint {
			encoder.outputFormatting = .prettyPrinted
		}

		let data = try encoder.encode(self)
		guard let string = String(data: data, encoding: .utf8) else {
			throw EncodeError.stringEncodingFail
		}
		return string
	}
}

extension Array where Element: HappyEncodable {
	public func toJSON() throws -> [[String: Any]] {
		try self.map {
			try $0.toJSON()
		}
	}

	public func toJSONString(prettyPrint: Bool = false) throws -> String {
		return """
		[
			\(try self.map {
			  try $0.toJSONString(prettyPrint: prettyPrint)
			}
			.joined(separator: ",\(prettyPrint ? "\n\t" : "")"))
		]
		"""
	}
}
