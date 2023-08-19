//
//  SyntaxStringInterpolation.swift
//  HappyCodable
//
//

import Foundation
import SwiftSyntaxBuilder

extension SyntaxStringInterpolation {
	mutating func appendInterpolation<T>(raw value: T, enable: Bool) where T: CustomStringConvertible, T: TextOutputStreamable {
		if enable {
			appendLiteral("\(value)")
		}
	}
}
