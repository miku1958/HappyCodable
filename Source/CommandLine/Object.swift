//
//  Object.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation
import SourceKittenFramework

public struct Object: Codable {
	var customCodingKeys: [CodingKey]?
	var isExtension: Bool = false
	let accessLevel: AccessLevel
	let name: String
	let type: Types?
	let inheritedtypes: [String]
	let subObjects: [Object]
	let propertys: [Property]
	
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
	
	enum AccessLevel: String, Codable, CaseIterable {
		case `private`, `fileprivate`, `internal`, `public`, `open`
		
		var isPublic: Bool {
			switch self {
			case .fileprivate, .private, .internal:
				return false
			case .public, .open:
				return true
			}
		}
		
		var isPrivate: Bool {
			switch self {
			case .fileprivate, .private:
				return true
			case .internal, .public, .open:
				return false
			}
		}
	}
	
	enum Types: Int, Codable {
		case `class`
		case `enum`
		case `struct`
	}
	
	struct CodingKey: Codable {
		let property: String
		let alter: String?
		
		var key: String {
			alter ?? property
		}
	}
}

extension Object.AccessLevel: Comparable {
	static func < (lhs: Object.AccessLevel, rhs: Object.AccessLevel) -> Bool {
		if lhs.isPublic, rhs.isPublic {
			return false
		}
		return Object.AccessLevel.allCases.firstIndex(of: lhs)! < Object.AccessLevel.allCases.firstIndex(of: rhs)!
	}
}

extension Object {
	init?(_ source: [String: SourceKitRepresentable], file: File, inheritedAccessLevel: AccessLevel?) {
		guard
			let name = source[SwiftDocKey.name]?.string
		else { return nil }
		
		var accessLevel: Object.AccessLevel
		if let value = source["key.accessibility"]?.string?.replacingOccurrences(of: "source.lang.swift.accessibility.", with: ""), let accessibility = Object.AccessLevel(rawValue: value) {
			accessLevel = accessibility
		} else {
			accessLevel = .internal
		}
		if let inheritedAccessLevel = inheritedAccessLevel, accessLevel > inheritedAccessLevel {
			accessLevel = inheritedAccessLevel
		}
		
		#if DEBUG
		if name == "SubEnumComplex" {
			
		}
		#endif
		var propertys = [Object.Property]()
		var subObjects = [Object]()
		if let substructures = source[SwiftDocKey.substructure]?.dicArray {
			for structure in substructures {
				if let kind = structure[SwiftDocKey.kind]?.string.flatMap(SwiftDeclarationKind.init(rawValue:)) {
					switch kind {
					case .enumcase:
						propertys += Property.enumElements(structure, file: file)
					default:
						if let property = Object.Property(structure, file: file) {
							propertys.append(property)
						} else if let object = Object(structure, file: file, inheritedAccessLevel: accessLevel) {
							subObjects.append(object)
						}
					}
				} else {
					
				}
			}
		}
		
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
		
		self.init(accessLevel: accessLevel, name: name, type: type, inheritedtypes: inheritedtypes, subObjects: subObjects, propertys: propertys)
	}
}
