//
//  Macros.swift
//  HappyCodable
//
//

import Foundation
import HappyCodableShared
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AttributePlaceholderMacro: PeerMacro {
	public static func expansion(
		of node: SwiftSyntax.AttributeSyntax,
		providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
		in context: some SwiftSyntaxMacros.MacroExpansionContext
	) throws -> [SwiftSyntax.DeclSyntax] {
		[]
	}
}

public struct HappyCodableMemberMacro: MemberMacro {
	class Conditions {
		var hasCodingKeys = false
		var hasInitFrom = false
		var hasInit = false
		var hasEncodeTo = false
		var codingKeysOverride: [String: String] = [:]
	}

	static func handleCodingKeys(
		decl: EnumDeclSyntax,
		into conditions: Conditions
	) {
		conditions.hasCodingKeys = true
		decl.memberBlock.members.compactMap {
			$0.decl.as(EnumCaseDeclSyntax.self)?.elements
		}
		.joined()
		.forEach { `case` in
			let name = `case`.name.text
			let alterName: String
			guard let value = `case`.rawValue?.value else {
				return
			}
			if let stringValue = value.as(StringLiteralExprSyntax.self) {
				alterName = stringValue.segments.trimmedDescription
			} else if let intValue = value.as(IntegerLiteralExprSyntax.self) {
				alterName = intValue.trimmedDescription
			} else {
				return
			}
			conditions.codingKeysOverride[name] = alterName
		}
	}

	@available(macOS 13.0, iOS 16.0, *)
	static func checkCustomCodable(
		of member: MemberBlockItemSyntax,
		into conditions: Conditions
	) {
		if let enumDecl = member.decl.as(EnumDeclSyntax.self), enumDecl.name.text == "CodingKeys" {
			handleCodingKeys(decl: enumDecl, into: conditions)
		}

		if let syntax = member.decl.as(InitializerDeclSyntax.self) {
			let rex = /\s*?\(\s*?from\s+?decoder\s*?:\s*?(Foundation\.)?Decoder\s*?\)\s+?throws\s*?/
			let match = (try? rex.firstMatch(in: syntax.signature.description)) != nil
			if match {
				conditions.hasInitFrom = true
			} else {
				conditions.hasInit = true
			}
		}

		if ({
			guard
				let syntax = member.decl.as(FunctionDeclSyntax.self),
				syntax.name.text == "encode"
			else {
				return false
			}

			let rex = /\s*?\(\s*?to\s+?encoder\s*?:\s*?(Foundation\.)?Encoder\s*?\)\s+?throws\s*?/
			return (try? rex.firstMatch(in: syntax.signature.description)) != nil
		}()) {
			conditions.hasEncodeTo = true
		}
	}

	static func generateCodableItems(
		from memberList: MemberBlockItemListSyntax,
		in context: some MacroExpansionContext,
		into conditions: Conditions
	) -> [CodableItem] {
		memberList.compactMap { member -> CodableItem? in
			// is a property
			guard
				let property = member.decl.as(VariableDeclSyntax.self),
				!property.modifiers.contains(where: {
					$0.name.tokenKind == .keyword(.static)
				}),
				property.bindings.count == 1,
				let propertyBinding = property.bindings.first,
				propertyBinding.accessorBlock?.is(AccessorBlockSyntax.self) != true,
				let propertyName = propertyBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
			else {
				if #available(macOS 13.0, iOS 16.0, *) {
					checkCustomCodable(of: member, into: conditions)
				}
				return nil
			}

			var defaultValue: String?

			if let value = propertyBinding.initializer?.value {
				defaultValue = value.description
			}

			if defaultValue == nil,
			   let propertyType = propertyBinding.typeAnnotation?.type.description.trimmingCharacters(in: .whitespacesAndNewlines),
			   (propertyType.hasSuffix("?") || propertyType.hasPrefix("Optional<")) {
				defaultValue = "nil"
			}
			if defaultValue == nil,
			   propertyBinding.accessorBlock?.is(CodeBlockSyntax.self) != true {
				context.diagnose(
					Diagnostic(
						node: Syntax(property),
						message: SimpleDiagnosticMessage(
							message: "property \(propertyName) has no default value, decode failure will throw an error, consider giving it a default value or changing it to Optional?",
							diagnosticID: MessageID(domain: "HappyCodable", id: "warning"),
							severity: .warning
						)
					)
				)
			}

			var item = CodableItem(name: propertyName, defaultValue: defaultValue)
			let attributes = property.attributes.compactMap {
				$0.as(AttributeSyntax.self)
			}
			for attribute in attributes {
				let arguments = attribute.arguments?.as(LabeledExprListSyntax.self)
				let encodeArgument = arguments?["encode"]?.description
				let decodeArgument = arguments?["decode"]?.description

				switch "\(attribute.attributeName)" {
				case "HappyAlterCodingKeys":
					guard let arguments = arguments?.map(\.expression), !arguments.isEmpty else {
						context.diagnose(
							Diagnostic(
								node: Syntax(attribute),
								message: SimpleDiagnosticMessage(
									message: "Alter keys is empty, consider removing it",
									diagnosticID: MessageID(domain: "HappyCodable", id: "warning"),
									severity: .warning
								)
							)
						)
						break
					}
					item.alterKeys = arguments.map {
						"\($0)"
					}
				case "HappyDataStrategy":
					item.dataStrategy = .init(
						encode: encodeArgument ?? ".deferredToData",
						decode: decodeArgument ?? ".deferredToData"
					)
				case "HappyDateStrategy":
					item.dateStrategy = .init(
						encode: encodeArgument ?? ".deferredToDate",
						decode: decodeArgument ?? ".deferredToDate"
					)
				case "HappyNonConformingFloatStrategy":
					item.nonConformingFloatStrategy = .init(
						encode: encodeArgument ?? ".throw",
						decode: decodeArgument ?? ".throw"
					)
				case "HappyElementNullable":
					item.elementNullable = true
				case "HappyUncoding":
					item.uncoding = true
					if item.defaultValue == nil {
						context.diagnose(
							Diagnostic(
								node: Syntax(attribute),
								message: SimpleDiagnosticMessage(
									message: "Uncoding requires a default value",
									diagnosticID: MessageID(domain: "HappyCodable", id: "warning"),
									severity: .error
								)
							)
						)
					}
				default:
					break
				}
			}
			return item
		}
	}

	public static func expansion(
		of node: AttributeSyntax,
		providingMembersOf declaration: some DeclGroupSyntax,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		var disableWarnings: Set<Warnings> = []
		node.arguments?.as(LabeledExprListSyntax.self)?.forEach {
			if $0.label?.text == "disableWarnings" {
				guard let arrayExpr = $0.expression.as(ArrayExprSyntax.self) else {
					context.diagnose(
						Diagnostic(
							node: Syntax(node),
							message: SimpleDiagnosticMessage(
								message: "disableWarnings only support static Array literal",
								diagnosticID: MessageID(domain: "HappyCodable", id: "warning"),
								severity: .warning
							)
						)
					)
					return
				}
				arrayExpr
					.elements
					.forEach {
						guard
							let name = $0.expression.description.split(separator: ".").last,
							let warning = Warnings(rawValue: String(name))
						else {
							return
						}
						disableWarnings.insert(warning)
					}
			}
		}
		if declaration.is(EnumDeclSyntax.self) {
			context.diagnose(
				Diagnostic(
					node: Syntax(node),
					message: SimpleDiagnosticMessage(
						message: "HappyCodable has no effect on Enum, consider removing it",
						diagnosticID: MessageID(domain: "HappyCodable", id: "warning"),
						severity: .warning
					)
				)
			)
			return []
		}
		guard
			let inheritedTypes = (declaration as? DeclSyntaxProtocolHelper)?.inheritedTypes,
			let hasHappyEncodable = !inheritedTypes.isDisjoint(with: [ "HappyCodable", "HappyEncodable"]) as Bool?,
			let hasHappyDecodable = !inheritedTypes.isDisjoint(with: ["HappyCodable", "HappyDecodable"]) as Bool?,
			(hasHappyEncodable || hasHappyDecodable)
		else {
			context.diagnose(
				Diagnostic(
					node: Syntax(node),
					message: SimpleDiagnosticMessage(
						message: "Missing HappyCodable, HappyEncodable or HappyDecodable",
						diagnosticID: MessageID(domain: "HappyCodable", id: "error"),
						severity: .error
					)
				)
			)
			return []
		}

		let memberList = declaration.memberBlock.members

		let conditions = Conditions()

		let codableItems: [CodableItem] = generateCodableItems(from: memberList, in: context, into: conditions)

		let needCoder = !codableItems.allSatisfy {
			$0.uncoding
		}

		var codingKeys: DeclSyntax?
		var initcoder: DeclSyntax?
		var encodeto: DeclSyntax?

		let modifier: String
		if declaration.is(ClassDeclSyntax.self) {
			modifier = "required"
		} else {
			modifier = ""
		}

		if !conditions.hasInit, disableWarnings.isDisjoint(with: [.all, .noInitializer]) {
			context.diagnose(
				Diagnostic(
					node: Syntax(declaration),
					message: SimpleDiagnosticMessage(
						message: "Due to the limitation, @HappyCodable causes the autosynthesis initializer to fail, if you don't need a initializer, you can use @HappyCodable(disableWarnings: [.noInitializer])",
						diagnosticID: MessageID(domain: "HappyCodable", id: "warning"),
						severity: .warning
					)
				)
			)
		}

		let itemCodingKeys = codableItems.compactMap {
			$0.codingKey(override: conditions.codingKeysOverride)
		}

		if !conditions.hasCodingKeys, !itemCodingKeys.isEmpty {
			codingKeys = """

			enum CodingKeys: Swift.String, Swift.CodingKey {
				\(raw: itemCodingKeys.joined(separator: "\n"))
			}

			"""
		}

		if !conditions.hasInitFrom, hasHappyDecodable {
			initcoder = """

			public \(raw: modifier) init(from decoder: Swift.Decoder) throws {
				\(raw: "let container = try decoder.container(keyedBy: Swift.String.self)", enable: needCoder)
				\(raw: "var errors = [Swift.Error]()", enable: needCoder)
				\(raw: codableItems.map(\.decode).joined(separator: "\n"))
				\(raw: "Self.decodeHelper.errorsReporter?(errors)", enable: needCoder)
				\(raw: "self.didFinishDecoding()")
			}

			"""
		}

		if !conditions.hasEncodeTo, hasHappyEncodable {
			// `_ = encoder.container(keyedBy: Swift.String.self)` is added for removing "\(type) did not encode any values" error
			encodeto = """

			public func encode(to encoder: Swift.Encoder) throws {
				\(raw: "self.willStartEncoding()")
				\(raw: "var container = encoder.container(keyedBy: Swift.String.self)", enable: needCoder)
				\(raw: "_ = encoder.container(keyedBy: Swift.String.self)", enable: !needCoder)
				\(raw: "var errors = [Swift.Error]()", enable: needCoder)
				\(raw: codableItems.map(\.encode).joined(separator: "\n"))
				\(raw: "Self.encodeHelper.errorsReporter?(errors)", enable: needCoder)
			}

			"""
		}

		return [
			codingKeys,
			initcoder,
			encodeto
		].compactMap {
			$0
		}
	}
}
