//
//  AnyCodable.swift
//  HappyCodable
//
//

import Foundation

enum AnyDecodableStorage {
	@ThreadLocalStorage
	static var designatedPaths: [String] = []
}

indirect enum AnyDecodable<R: Decodable>: Decodable {
	case anyDecodable(AnyDecodable)
	case value(R)

	init(from decoder: Decoder) throws {
		if let key = AnyDecodableStorage.designatedPaths.removeFirstIfHas() {
			let container = try decoder.container(keyedBy: Swift.String.self)
			if container.allKeys.contains(key) {
				self = try container.decode(AnyDecodable.self, forKey: key)
			} else {
				throw DecodeError.invalidDesignatedPath
			}
		} else if let value = try? decoder.singleValueContainer().decode(R.self) {
			self = .value(value)
		} else {
			throw DecodeError.invalidDesignatedPath
		}
	}

	func getSingleValue() -> R {
		switch self {
		case .anyDecodable(let anyDecodable):
			return anyDecodable.getSingleValue()
		case .value(let value):
			return value
		}
	}
}
