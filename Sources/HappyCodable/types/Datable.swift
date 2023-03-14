//
//  Datable.swift
//  HappyCodable
//
//

import Foundation

public protocol Datable {
	var data: Data { get throws }
}

extension Data: Datable {
	public var data: Data { self }
}

extension [String: Any]: Datable {
	public var data: Data {
		get throws {
			try JSONSerialization.data(withJSONObject: self)
		}
	}
}

extension String: Datable {
	public var data: Data {
		get throws {
			guard let data = data(using: .utf8) else {
				throw DecodeError.datableFail
			}
			return data
		}
	}
}

extension NSDictionary: Datable {
	public var data: Data {
		get throws {
			try JSONSerialization.data(withJSONObject: self)
		}
	}
}
