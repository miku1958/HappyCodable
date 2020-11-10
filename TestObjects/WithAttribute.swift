//
//  WithAttribute.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/7/31.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct TestStruct_withAttribute: HappyCodable {
	@Happy.alterCodingKeys("codingKey1", "codingKey2", "🍉")
	public var codingKeys: Int = 0
	
	public var optional_allow: Int?
	
	public var optional_notAllow: Int?
	
	@Happy.uncoding
	public var uncoding: Int = 0
	
}
