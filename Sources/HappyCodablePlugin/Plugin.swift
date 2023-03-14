//
//  Plugin.swift
//  HappyCodable
//
//

#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MyPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		AttributePlaceholderMacro.self,
		HappyCodableMemberMacro.self,
	]
}
#endif
