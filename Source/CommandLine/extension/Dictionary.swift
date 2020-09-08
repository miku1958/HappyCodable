//
//  Dictionary.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation
import SourceKittenFramework

extension Dictionary where Key == String, Value == SourceKittenFramework.SourceKitRepresentable {
	public subscript(_ key: SourceKittenFramework.SwiftDocKey) -> Value? {
		get {
			self[key.rawValue]
		}
		set {
			self[key.rawValue] = newValue
		}
	}
}
