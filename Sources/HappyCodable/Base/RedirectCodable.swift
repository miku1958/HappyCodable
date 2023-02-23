//
//  RedirectCodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/25.
//

import Foundation

struct RedirectCodable<T> {
	let direct: T
}

extension RedirectCodable: Encodable where T: Encodable {
	@inline(__always)
	func encode(to encoder: Encoder) throws {
		try direct.encode(to: encoder)
	}
}

extension RedirectCodable: Decodable where T: Decodable {
	@inline(__always)
	init(from decoder: Decoder) throws {
		direct = try T.init(from: decoder)
	}
}
