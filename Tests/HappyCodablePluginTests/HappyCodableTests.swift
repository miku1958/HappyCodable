//
//  HappyCodableTests.swift
//  HappyCodable
//
//

import Foundation
import HappyCodablePlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import XCTest

enum TestEnum: Codable {
	case value1(arg1: Int, arg2: Int)
	case value2(Int, arg2: Int)
	case value3
}

final class HappyCodableTests: XCTestCase {
	func testStringify() {
		let testMacros: [String: Macro.Type] = [
			"HappyCodable": HappyCodableMemberMacro.self,
		]
		let sf: SourceFileSyntax =
#"""
@HappyCodable(disableWarnings: [.noInitializer])
struct TestStruct_dynamicDefault: HappyCodable {
	var intDynamic: Int = Int.random(in: 0...100)
	var intStatic: Int = 1
}
"""#
		let context = BasicMacroExpansionContext(
			sourceFiles: [sf: .init(moduleName: "MyModule", fullFilePath: "test.swift")]
		)
		let transformedSF = sf.expand(macros: testMacros, in: context)
		XCTAssertEqual(
			transformedSF.description,
	  #"""
	  let a = (x + y, "x + y")
	  let b = ("Hello, \(name)", #""Hello, \(name)""#)
	  """#
		)
	}
}
