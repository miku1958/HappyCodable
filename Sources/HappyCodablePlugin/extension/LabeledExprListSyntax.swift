//
//  LabeledExprListSyntax.swift
//  HappyCodable
//
//

import SwiftSyntax

extension LabeledExprListSyntax {
	subscript(label: String) -> ExprSyntax? {
		self.first {
			$0.label?.text == label
		}?.expression
	}
}
