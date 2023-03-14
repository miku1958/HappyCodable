//
//  Array+Extension.swift
//  HappyCodable
//
//

import Foundation

extension Array {
	@discardableResult
	@inlinable
	mutating func removeFirstIfHas() -> Element? {
		if self.isEmpty {
			return nil
		} else {
			return removeFirst()
		}
	}
}
