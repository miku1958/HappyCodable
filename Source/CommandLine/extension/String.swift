//
//  String.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

#if canImport(Foundation)
import Foundation
#endif

extension String {
	func range(of: String? = nil, from: [String], to: [String], in searchRange: Range<Index>? = nil, options: CompareOptions = [], locale: Locale? = nil) -> Range<Index>? {
		var startIndex = self.startIndex
		var endIndex = self.endIndex
		if let range = searchRange {
			startIndex = max(range.lowerBound, startIndex)
			endIndex = min(range.upperBound, endIndex)
		}
		let searchRange = Range(uncheckedBounds: (startIndex, endIndex))
		for f in from {
			if let range = range(of: f, options: [], range: searchRange, locale: nil) {
				startIndex = max(range.upperBound, startIndex)
			}
		}
		for t in to {
			if let range = range(of: t, options: [], range: searchRange, locale: nil), range.lowerBound > startIndex {
				endIndex = min(range.lowerBound, endIndex)
			}
		}
		let checkRange = Range(uncheckedBounds: (startIndex, endIndex))
		if let of = of {
			return range(of: of, options: options, range: checkRange, locale: locale)
		} else {
			return checkRange
		}
	}
}

extension StringProtocol {
	var removingQuotes: String {
		var result = String(self)
		while result.first == "\"" {
			result.removeFirst()
		}
		while result.last == "\"" {
			result.removeLast()
		}
		return result
	}
	var removingBackQuotes: String {
		var result = String(self)
		if result.first == "`" {
			result.removeFirst()
		}
		if result.last == "`" {
			result.removeLast()
		}
		return result
	}
	var removingSpaceInHeadAndTail: String {
		var string = String(self)
		while string.first == " " {
			string.removeFirst()
		}
		while string.last == " " {
			string.removeLast()
		}
		return string
	}
}

extension String.StringInterpolation {
	mutating func appendInterpolation<S>(indent count: Int, _ content: S) where S: StringProtocol {
		var lines = content.split(separator: "\n").map(String.init(_:))
		for index in 0..<lines.count {
			lines[index] = String(Array(repeating: "\t", count: count)) + lines[index]
		}
		
		appendLiteral(lines.joined(separator: "\n"))
	}
}
