//
//  SourceKitRepresentable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation
import SourceKittenFramework

extension SourceKittenFramework.SourceKitRepresentable {
	var dictionary: [String: SourceKitRepresentable]? {
		self as? [String: SourceKitRepresentable]
	}
	var array: [SourceKitRepresentable]? {
		self as? [SourceKitRepresentable]
	}
	var dicArray: [[String: SourceKitRepresentable]]? {
		self as? [[String: SourceKitRepresentable]]
	}
	var string: String? {
		self as? String
	}
	var int: Int? {
		(self as? Int64).map(Int.init)
	}
}
