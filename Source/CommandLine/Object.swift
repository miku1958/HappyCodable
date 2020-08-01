//
//  Object.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation
import SourceKittenFramework

public struct Object: Codable {
	let name: String
	let type: Types?
	let inheritedtypes: [String]
	var isExtension: Bool = false
	let propertys: [Property]
	var customCodingKeys: [String]?
	
	var isClass: Bool {
		type == .class
	}
	
	var isConfirmToEncodable: Bool {
		inheritedtypes.contains(where: {
			$0.contains("HappyEncodable")
		}) || inheritedtypes.contains(where: {
			$0.contains("HappyCodable")
		})
	}
	var isConfirmToDecodable: Bool {
		inheritedtypes.contains(where: {
			$0.contains("HappyDecodable")
		}) || inheritedtypes.contains(where: {
			$0.contains("HappyCodable")
		})
	}
	
	enum Types: Int, Codable {
		case `class`
		case `enum`
		case `struct`
	}
}

extension Object {
	init?(_ source: [String: SourceKitRepresentable], file: File) {
		guard
			let name = source[SwiftDocKey.name]?.string
		else { return nil }
		#if DEBUG
		if name == "HappyTest" {
			
		}
		#endif
		let propertys: [Object.Property] = source[SwiftDocKey.substructure]?.dicArray?.flatMap({ property -> [Object.Property] in
			guard
				let kind = property[SwiftDocKey.kind]?.string.flatMap(SwiftDeclarationKind.init(rawValue:))
			else { return [] }
			
			switch kind {
			case .enumcase:
				return Property.enumElements(property, file: file)
			default:
				if let property = Object.Property(property, file: file) {
					return [property]
				} else {
					return []
				}
			}
		}) ?? []
		var type: Types?
		if let kind = source[SwiftDocKey.kind]?.string.flatMap(SwiftDeclarationKind.init(rawValue:)) {
			switch kind {
			case .class:
				type = .class
			case .enum:
				type = .enum
			case .struct:
				type = .struct
			default: break
			}
		}
		var inheritedtypes = [String]()
		if let _inheritedtypes = source[SwiftDocKey.inheritedtypes]?.dicArray {
			inheritedtypes = _inheritedtypes.compactMap({
				$0[SwiftDocKey.name]?.string
			})
		}
		self.init(name: name, type: type, inheritedtypes: inheritedtypes, propertys: propertys)
	}
}
