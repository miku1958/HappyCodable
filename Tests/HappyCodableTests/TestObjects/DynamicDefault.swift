//
//  DynamicDefault.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable
import SwiftData

@HappyCodable(disableWarnings: [.noInitializer])
struct TestStruct_dynamicDefault: HappyCodable {
	var intDynamic: Int = Int.random(in: 0...100)
	var intStatic: Int = 1
}
