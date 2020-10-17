//
//  RedirectCodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/25.
//

import Foundation

struct RedirectCodable<T: Codable>: Codable {
	let direct: T
	
	init(direct: T) {
		self.direct = direct
	}
	
	@inline(__always)
	init(from decoder: Decoder) throws {
		direct = try T.init(from: decoder)
	}
	
	@inline(__always)
	func encode(to encoder: Encoder) throws {
		try direct.encode(to: encoder)
	}
}
