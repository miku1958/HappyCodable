//
//  DeclSyntaxProtocolHelper.swift
//  HappyCodable
//
//

import SwiftSyntax

protocol DeclSyntaxProtocolHelper {
	var inheritanceClause: InheritanceClauseSyntax? { get }
}

extension DeclSyntaxProtocolHelper {
	var inheritedTypes: Set<String>? {
		guard let types = inheritanceClause?
			.inheritedTypes
			.compactMap({
				$0.type.as(IdentifierTypeSyntax.self)?.name.text
			})
		else {
			return []
		}
		return Set(types)
	}
}

extension StructDeclSyntax: DeclSyntaxProtocolHelper {

}

extension ClassDeclSyntax: DeclSyntaxProtocolHelper {

}

// Swift complier can handle enum correctly, no need to get involved
// extension EnumDeclSyntax: DeclSyntaxProtocolHelper { }

extension ActorDeclSyntax: DeclSyntaxProtocolHelper {

}
