//
//  HappyCodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/5/23.
//

import Foundation


// MARK: - HappyCodableSerialization
public protocol HappyCodableSerialization {
	
}

// MARK: - Type
// MARK: - HappyEncodable
public protocol HappyCodable: Encodable, Decodable {
	init()
	mutating func didFinishMapping()
}
extension HappyCodable {
	public func didFinishMapping() { }
}

extension HappyCodable {
	static func defaultModelEncodeJSON() -> [String: Any] {
		do {
			let json = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self.init()), options: .allowFragments)
			return json as? [String: Any] ?? [:]
		} catch {
			return [:]
		}
	}
}
