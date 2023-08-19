//
//  WithAttribute.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

@HappyCodable
struct TestStruct_withAttribute: HappyCodable {
	@AlterCodingKeys("codingKey1", "codingKey2", "🍉")
	var codingKeys: Int = 0

	var optional_allow: Int?

	var optional_notAllow: Int?

	@Uncoding
	var uncoding: Int = 0

	init(codingKeys: Int = 0, optional_allow: Int? = nil, optional_notAllow: Int? = nil, uncoding: Int = 0) {
		self.codingKeys = codingKeys
		self.optional_allow = optional_allow
		self.optional_notAllow = optional_notAllow
		self.uncoding = uncoding
	}
}
