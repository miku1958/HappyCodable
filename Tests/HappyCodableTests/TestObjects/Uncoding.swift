//
//  Uncoding.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

@HappyCodable
struct TestStruct_uncoding: HappyCodable {
	@HappyUncoding
	var uncoing: NotCodable = NotCodable(int: Self.fakeData_int)

	@HappyUncoding
	var uncoingOptional: NotCodable?

	static let fakeData_int: Int = Int.random(in: 0...1000000)

	struct NotCodable: Equatable {
		let int: Int
	}

	init(uncoing: NotCodable = NotCodable(int: Self.fakeData_int), uncoingOptional: NotCodable? = nil) {
		self.uncoing = uncoing
		self.uncoingOptional = uncoingOptional
	}
}
