//
//  Encodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/18.
//

import Foundation

public enum EncodeError: String, Swift.Error {
	case stringEncodingFail
	case toJSONTypeFail
}

public extension HappyCodable {
	func toJSON() throws -> [String: Any] {
		let encoder = JSONEncoder()
		let data = try encoder.encode(self)
		guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
			throw EncodeError.toJSONTypeFail
		}
		return object
	}
	
	func toJSONString(prettyPrint: Bool = false) throws -> String {
		let encoder = JSONEncoder()
		
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

public extension Array where Element: HappyCodable {
	
	func toJSON() throws -> [[String: Any]] {
		try self.map {
			try $0.toJSON()
		}
	}
	
	func toJSONString(prettyPrint: Bool = false) throws -> String {
		let string =
		"""
		[
			\(try self.map {
				try $0.toJSONString(prettyPrint: prettyPrint)
			}.joined(separator: ",\(prettyPrint ? "\n\t" : "")"))
		]
		"""
		return string
	}
}
