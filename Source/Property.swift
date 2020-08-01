//
//  Property.swift
//  Pods
//
//  Created by 庄黛淳华 on 2020/7/31.
//

import Foundation
import SourceKittenFramework

extension Object {
	struct Property: Codable {
		let name: String
		let type: Types
		let attributes: [Attribute]
		let accessibilitys: [Accessibility]
		
		struct Function {
			var parameters: [Parameter] = []
			var returnType: String = "()"
			init(parameters: [Parameter] = []) {
				self.parameters = parameters
			}
			init?(_ content: String) {
				guard content.contains(",") else { return nil }
				var types = content.split(separator: ",").map(String.init)
				returnType = types.removeLast()
				parameters = types.compactMap(Parameter.init(string:))
			}
			var encodeString: String {
				(
					parameters.map({
						$0.encodeString
					}) + [returnType]
				).joined(separator: ",")
			}
			
			struct Parameter {
				let name: String
				let alterName: String?
				let type: String
				let defaultValue: String?
				
				init(name: String, alterName: String? = nil, type: String, defaultValue: String? = nil) {
					self.name = name
					self.alterName = alterName
					self.type = type
					self.defaultValue = defaultValue
				}
				init?(string: String) {
					let para = string.split(separator: ",").map(String.init)
					guard para.count == 4 else { return nil }
					name = para[0]
					if para[1].isEmpty {
						alterName = nil
					} else {
						alterName = para[1]
					}
					type = para[2]
					if para[3].isEmpty {
						defaultValue = nil
					} else {
						defaultValue = para[3]
					}
				}
				
				var encodeString: String {
					"\(name),\(alterName ?? ""),\(type),\(defaultValue ?? "")"
				}
				
				static func parse(from name: String, file: File, offset: Int?) -> [Parameter] {
					
					guard
						name.contains("("), name.contains(")"),
						let offset = offset,
						let contentsFromName = file.contents(from: offset)?
							.replacingOccurrences(of: "\n", with: "")
							.replacingOccurrences(of: "\t", with: "")
					else { return [] }
					
					var definedString = ""
					do {
						var leftBracketCount = 0
						var rightBracketCount = 0
						for char in contentsFromName {
							if char == "(" {
								leftBracketCount += 1
							} else if char == ")" {
								rightBracketCount += 1
							}
							definedString.append(char)
							if leftBracketCount > 0, leftBracketCount == rightBracketCount {
								break
							}
						}
					};
					
					while definedString.contains("  ") {
						definedString = definedString
							.replacingOccurrences(of: "  ", with: " ")
					}
					let shortName: String
					if let end1 = definedString.firstIndex(of: "(") {
						if
							let end2 = definedString.firstIndex(of: "<"),
							end2 > definedString.startIndex { // 防止遇到"<(_:_:)"
							shortName = definedString[..<min(end1, end2)]
								.removingSpaceInHeadAndTail
						} else {
							shortName = definedString[..<end1]
								.removingSpaceInHeadAndTail
						}
					} else {
						return []
					}
					var result = [Parameter]()
					do {
						var left = 0
						func addPara(to index: Int) {
							let leftIndex = definedString.index(definedString.startIndex, offsetBy: left+1)
							left = index
							
							let rightIndex = definedString.index(definedString.startIndex, offsetBy: index)
							
							let name_type = definedString[leftIndex..<rightIndex]
							let colonIndex = name_type.firstIndex(of: ":")
							var type: String
							
							if let colonIndex = colonIndex {
								type = String(name_type[name_type.index(after: colonIndex)...])
							} else {
								type = String(name_type)
							}
							type = type
								.replacingOccurrences(of: "@escaping", with: "")
							var defaultValue: String?
							do {
								var bracket = 0
								for (index, char) in type.enumerated() {
									if char == "(" {
										bracket += 1
									} else if char == ")" {
										bracket -= 1
									} else if bracket == 0, char == "=" {
										defaultValue = String(type[type.index(type.startIndex, offsetBy: index+1)...])
											.removingSpaceInHeadAndTail
										type = String(type[..<type.index(type.startIndex, offsetBy: index)])
										break
									}
								}
							}
							type = type
								.removingSpaceInHeadAndTail
							let names: [Substring]
							if let colonIndex = colonIndex {
								names = name_type[name_type.startIndex..<colonIndex].split(separator: " ")
							} else {
								names = []
							}
							
							let name: String
							let alterName: String?
							if names.isEmpty {
								name = "_"
								alterName = nil
							} else if names.count == 1 {
								name = names[0]
									.removingSpaceInHeadAndTail
								if anonymousFunctionShortNames.contains(shortName) {
									alterName = "_"
								} else {
									alterName = nil
								}
							} else {
								alterName = names[0]
									.removingSpaceInHeadAndTail
								name = names[1]
									.removingSpaceInHeadAndTail
							}
							result.append(Parameter(name: name, alterName: alterName, type: type, defaultValue: defaultValue))
						}
						
						var bracket = 0
						for (index, char) in definedString.enumerated() {
							if char == "(" {
								bracket += 1
								if bracket == 1 {
									left = index
								}
							} else if char == ")" {
								bracket -= 1
								if bracket == 0 {
									addPara(to: index)
								}
							} else if bracket == 1, char == "," {
								addPara(to: index)
							}
						}
					}
					#if DEBUG
					if name == "<(_:_:)" {
						
					}
					if // test
						let leftIndex = name.firstIndex(of: "("),
						let rightIndex = name.lastIndex(of: ")") {
						// then
						let names = name[name.index(after: leftIndex)..<rightIndex].split(separator: ":")
						for (index, name) in names.enumerated() {
							let para = result[index]
							
							if (para.alterName ?? para.name).removingBackQuotes != name {
								fatalError()
							}
						}
					}
					#endif
					return result
				}
			}
		}
		enum Instance {
			case type(String?)
			case function(Function)
			init(_ content: String?) {
				if let content = content, let function = Function(content) {
					self = .function(function)
				} else {
					self = .type(content)
				}
			}
			
			var encodeString: String? {
				switch self {
				case .type(let type):
					return type
				case .function(let function):
					return function.encodeString
				}
			}
		}
		enum Types: Codable {
			case instance(static: Bool, content: Instance)
			case function(static: Bool, content: Function)
			case enumElement(content: Instance)
			
			init(from decoder: Decoder) throws {
				let container = try decoder.singleValueContainer()
				let codes = try container.decode([String?].self)
				guard codes.count == 3 else {
					throw NSError(domain: "codes count wrong", code: -1, userInfo: nil)
				}
				if codes[0] == "0" {
					self = .instance(static: codes[1] == "1", content: .init(codes[2]))
				} else {
					self = .function(static: codes[1] == "1", content: Function(codes[2] ?? "") ?? Function() )
				}
			}
			
			func encode(to encoder: Encoder) throws {
				var container = encoder.singleValueContainer()
				switch self {
				case let .instance(isStatic, content):
					try container.encode(["0", (isStatic ? "1" : "0"), content.encodeString])
				case let .function(isStatic, content):
					try container.encode(["1", (isStatic ? "1" : "0"), content.encodeString])
				case let .enumElement(content):
					try container.encode(["2", content.encodeString])
				}
			}
		}
		enum Accessibility: Equatable, Codable {
			case get(accessible: Bool)
			case set(accessible: Bool)
			
			init(from decoder: Decoder) throws {
				let container = try decoder.singleValueContainer()
				try self.init(from: try container.decode(String.self))
			}
			
			func encode(to encoder: Encoder) throws {
				var container = encoder.singleValueContainer()
				try container.encode(encodedString)
			}
			
			init(from codes: String) throws {
				guard codes.count == 2 else {
					throw NSError(domain: "AccessibilityWrong", code: -1, userInfo: nil)
				}
				let codes = Array(codes)
				if codes[0] == "0" {
					self = .get(accessible: codes[1] == "1")
				} else {
					self = .set(accessible: codes[1] == "1")
				}
			}
			
			var encodedString: String {
				switch self {
				case .get(let accessible):
					return "0\(accessible ? 1 : 0)"
				case .set(let accessible):
					return "1\(accessible ? 1 : 0)"
				}
			}
		}
		
		enum Attribute: Codable, Equatable {
			case optional
			case codingKeys(keys: [String])
			case uncoding
			
			init(from decoder: Decoder) throws {
				let container = try decoder.singleValueContainer()
				let originalString = try container.decode(String.self)
				self.init(string: originalString)!
			}
			
			func encode(to encoder: Encoder) throws {
				var container = encoder.singleValueContainer()
				try container.encode(self.originalString)
			}
			
		}
	}
}

extension Object.Property {
	var replacedKey: String? {
		for attribute in attributes {
			if case let .codingKeys(keys) = attribute {
				return keys.first
			}
		}
		return nil
	}
	var alterKeys: [String] {
		for attribute in attributes {
			if case let .codingKeys(keys) = attribute, !keys.isEmpty {
				return keys[1...].map {
					$0.removingQuotes
				}
			}
		}
		return []
	}
	var isOptional: Bool{
		for attribute in attributes {
			if case  .optional = attribute {
				return true
			}
		}
		return false
	}
}

extension Object.Property {
	static func enumElements(_ property: [String: SourceKitRepresentable], file: File) -> [Self] {
		guard
			let elements = property[SwiftDocKey.substructure]?.dicArray,
			!elements.isEmpty
		else { return [] }
		return elements.compactMap { element in
			guard let kind = element[SwiftDocKey.kind]?.string.flatMap({
				SwiftDeclarationKind.init(rawValue:$0)
			}), kind == .enumelement else { return nil }
			guard let name = element[SwiftDocKey.name]?.string else { return nil }
			let parameters = Object.Property.Function.Parameter.parse(from: name, file: file, offset: element[SwiftDocKey.nameOffset]?.int)
			var accessibilitys = [Object.Property.Accessibility]()
			if let getAcc = element["key.accessibility"]?.string {
				accessibilitys.append(.get(accessible: !getAcc.contains("private")))
			}
			if parameters.isEmpty {
				return .init(name: name, type: .enumElement(content: .type(nil)), attributes: [], accessibilitys: accessibilitys)
			} else {
				return .init(name: name, type: .enumElement(content: .function(.init(parameters: parameters))), attributes: [], accessibilitys: accessibilitys)
			}
		}
	}
	init?(_ property: [String: SourceKitRepresentable], file: File) {
		guard
			let kind = property[SwiftDocKey.kind]?.string.flatMap(SwiftDeclarationKind.init(rawValue:)),
			let name = property[SwiftDocKey.name]?.string
		else { return nil }
		let type: Object.Property.Types
		let typeName = property[SwiftDocKey.typeName]?.string
		
		var accessibilitys = [Object.Property.Accessibility]()
		if let setAcc = property["key.setter_accessibility"]?.string {
			accessibilitys.append(.set(accessible: !setAcc.contains("private")))
		}
		if let getAcc = property["key.accessibility"]?.string {
			accessibilitys.append(.get(accessible: !getAcc.contains("private")))
		}
		let functionParas = Object.Property.Function.Parameter.parse(from: name, file: file, offset: property[SwiftDocKey.nameOffset]?.int)
		switch kind {
		case .varInstance, .varLocal, .varParameter:
			type = .instance(static: false, content: .type(typeName))
		case .varClass, .varGlobal, .varStatic:
			type = .instance(static: true, content: .type(typeName))
		case .functionMethodInstance:
			type = .function(static: false, content: .init(parameters: functionParas))
		case .functionMethodStatic, .functionMethodClass:
			type = .function(static: true, content: .init(parameters: functionParas))
		default:
			return nil
		}
		let attributes: [Object.Property.Attribute] = property["key.attributes"]?.dicArray?.filter({
			$0["key.attribute"]?.string == "source.decl.attribute._custom"
		}).compactMap({ attribute in
			guard
				let offset = attribute[SwiftDocKey.offset]?.int,
				let length = attribute[SwiftDocKey.length]?.int,
				let line_offset = file.stringView.lineAndCharacter(forByteOffset: .init(offset)),
				let content = file.lines.first(where: { $0.index == line_offset.line })?.content.utf8
			else { return nil }
			
			let beginIndex = content.index(content.startIndex, offsetBy: line_offset.character)
			
			let endIndex = content.index(beginIndex, offsetBy: length, limitedBy: content.endIndex) ?? content.endIndex
			
			return Object.Property.Attribute(string: String(content[beginIndex..<endIndex])!)
		}) ?? []
		self.init(name: name, type: type, attributes: attributes, accessibilitys: accessibilitys)
	}
}

extension Object.Property.Attribute {
	var originalString: String {
		switch self {
		case .optional:
			return "Happy.optional"
		case .codingKeys(let keys):
			return "Happy.codingKeys(\(keys.joined(separator: ",")))"
		case .uncoding:
			return "Happy.uncoding"
		}
	}
	init?<S>(string: S) where S: StringProtocol {
		if string.contains(Self.optional.originalString) {
			self = .optional
		} else if string.contains(Self.uncoding.originalString) {
			self = .uncoding
		} else if
			let startIndex = string.range(of: "Happy.codingKeys(")?.upperBound,
			let endIndex = string.lastIndex(of: ")") {
			// then
			let keys = string[startIndex..<endIndex].split(separator: ",").map {
				$0.removingSpaceInHeadAndTail
			}
			self = .codingKeys(keys: keys)
		}
		
		
		
		
		
		
		else {
			return nil
		}
	}
}
