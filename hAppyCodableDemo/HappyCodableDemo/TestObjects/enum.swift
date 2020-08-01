//
//  enum.swift
//  CommandLineTests
//
//  Created by 庄黛淳华 on 2020/7/31.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

enum TestEnum: String, HappyCodableEnum, CaseIterable {
	case case1
	case case2
}

enum TestEnumRawRepresentable: RawRepresentable, HappyCodableEnum {
	init?(rawValue: TestEnum) {
		switch rawValue {
		case .case1:
			self = .case1
		case .case2:
			self = .case2
		}
	}
	
	var rawValue: TestEnum {
		switch self {
		case .case1:
			return .case1
		case .case2:
			return .case2
		}
	}
	
	typealias RawValue = TestEnum
	
	case case1
	case case2
}

enum TestEnumComplex: HappyCodableEnum, Equatable {
	case value
	case function(int: Int, string: String)
}
