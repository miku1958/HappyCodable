//
//  DynamicDefault.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/9/26.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct TestStruct_dynamicDefault: HappyCodable {
	@Happy.dynamicDefault
	var intDynamic: Int = Int.random(in: 0...100)
	
	var intStatic: Int = Int.random(in: 0...100)
}
