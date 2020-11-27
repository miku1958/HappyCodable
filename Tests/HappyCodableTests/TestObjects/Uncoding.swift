//
//  Uncoding.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/9/26.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct TestStruct_uncoding: HappyCodable {
	@Happy.uncoding
	var uncoing = NotCodable(int: Self.fakeData_int)
	
	@Happy.uncoding
	var uncoingOptional: NotCodable?
	
	static let fakeData_int = Int.random(in: 0...1000000)
	
	struct NotCodable: Equatable {
		let int: Int
	}
}
