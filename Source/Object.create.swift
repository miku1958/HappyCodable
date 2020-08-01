//
//  Object.create.swift
//  Pods
//
//  Created by 庄黛淳华 on 2020/7/31.
//

import Foundation
import SourceKittenFramework

private extension Bool {
	func add(_ string: String) -> String {
		self ? "\(string)" : ""
	}
}

extension Array where Element == Object {
	var generatedCode: String {
		guard let definitionObject = self.first(where: { !$0.isExtension }) else { return "" }
		#if DEBUG
		if definitionObject.name == "BookDetail" {
			print(1)
		}
		#endif
		let customCodingKeys = self.compactMap {
			$0.customCodingKeys
		}.first
		let propertys = definitionObject.propertys
		let isConfirmToDecodable = self.contains {
			$0.isConfirmToDecodable
		}
		let isConfirmToEncodable = self.contains {
			$0.isConfirmToEncodable
		}
		let inheritedtypes = flatMap {
			$0.inheritedtypes
		}
		let methodNames = flatMap {
			$0.propertys.filter {
				if case let .function(isStatic, _/*content*/) = $0.type, !isStatic {
					return true
				} else {
					return false
				}
			}
		}.map {
			$0.name
		}
		
		var CodingKeys = ""
		var decode = ""
		var encode = ""
		
		func generatedType() {
			var codingKeyCases = ""
			
			var decodingVariables = ""
			
			var encodingVariables = ""
			
			for property in propertys {
				if !property.accessibilitys.contains(.set(accessible: true)) {
					continue
				}
				if property.attributes.contains(.uncoding) {
					continue
				}
				switch property.type {
				case let .instance(isStatic, _/*content*/):
					if isStatic {
						continue
					}
				case .function:
					continue
				case .enumElement:
					continue
				}
				if let customCodingKeys = customCodingKeys, !customCodingKeys.contains(property.name) {
					continue
				}
				
				do {
					if let replacingKey = property.replacedKey {
						codingKeyCases += "case \(property.name) = \(replacingKey)"
					} else {
						codingKeyCases += "case \(property.name)"
					}
					codingKeyCases += "\n"
				}
				if isConfirmToDecodable {
					let key = property.replacedKey?.removingQuotes ?? property.name
					
					let decodeExpression =
						"container.decode(default: self.\(property.name), key: \"\(key)\", alterKeys: \(property.alterKeys))"
					
					let decodeOnly =
						"self.\(property.name) = try \(decodeExpression)"
					
					let decodeAllowOptional =
						"do { \(decodeOnly) } catch { errors.append(error) }"
					// 这里只能一个一个的do catch, 不能放到同一个do catch里, 不然一个出错后面都不执行了
					
					decodingVariables += "\(decodeAllowOptional)\n"
				}
				if isConfirmToEncodable {
					let encodeParameters =
						"(self.\(property.name), forKey: .\(property.name))"
					
					let encodeSafely =
						"do { try container.encodeIfPresent\(encodeParameters) } catch { errors.append(error) }"
					
					encodingVariables += "\(encodeSafely)\n"
				}
			}
			guard !codingKeyCases.isEmpty else { return }
			
			CodingKeys =
				"""
			enum CodingKeys: String, CodingKey {
			\(indent: 1, codingKeyCases)
			}
			"""
			
			decode =
				"""
			\((!definitionObject.isClass).add("mutating"))
			func decode(happyFrom decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: StringCodingKey.self)
				var errors = [Error]()
			
				\(methodNames.contains("willStartMapping()").add("self.willStartMapping()"))

			\(indent: 1, decodingVariables)

				\(methodNames.contains("didFinishMapping()").add("self.didFinishMapping()"))

				if !Self.globalDecodeAllowOptional {
					throw errors
				}
			}
			"""
			
			encode =
				"""
			func encode(happyTo encoder: Encoder) throws {
				var container = encoder.container(keyedBy: CodingKeys.self)
				var errors = [Error]()

			\(indent: 1, encodingVariables)

				if !Self.globalEncodeSafely {
					throw errors
				}
			}
			"""
		}
		func generatedEnum() {
			var decodings = [String]()
			var encodings = [String]()
			for (index, property) in propertys.enumerated() {
				switch property.type {
				case .function:
					continue
				case .instance:
					continue
				case let .enumElement(content):
					var shortName = property.name
					if let index = shortName.firstIndex(of: "(") {
						shortName = String(shortName[..<index])
					}
					switch content {
					case .type:
						if isConfirmToDecodable {
							let code =
								"""
							case ".\(property.name)":
								self = .\(property.name)
							"""
							decodings.append(code)
						}
						
						if isConfirmToEncodable {
							let code =
								"""
							case .\(property.name):
								try container.encode([".\(property.name)": [String: String]()])
							"""
							encodings.append(code)
						}
						
					case let .function(function):
						if isConfirmToDecodable {
							let code =
								"""
							case ".\(property.name)":
								guard
							\(function.parameters.enumerated().map({ (index, para) -> String in
								let name: String
								if let alterName = para.alterName, alterName != "_" {
									name = alterName
								} else if para.name != "_" {
									name = para.name
								} else {
									name = "$\(index)"
								}
								return """
									let _\(index) = content[name]?["\(name)"]?.data(using: .utf8)
							"""
							}).joined(separator: ",\n"))
								else {
									throw error
								}
								
								self = .\(shortName)(
							\(function.parameters.enumerated().map({ (index, para) -> String in
								let name = para.alterName ?? para.name
								return """
									\((name != "_" && !name.isEmpty).add("\(name): "))try decoder.decode((\(para.type)).self, from: _\(index))
							"""
							}).joined(separator: ",\n"))
								)
							"""
							decodings.append(code)
						}
						
						if isConfirmToEncodable {
							let paras = (0..<function.parameters.count).map({
								"_\($0)"
							}).joined(separator: ", ")
							let code =
								"""
							case let .\(shortName)(\(paras)):
								try container.encode([
									".\(property.name)": [
							\(function.parameters.enumerated().map({ (index, para) -> String in
								let name: String
								if let alterName = para.alterName, alterName != "_" {
									name = alterName
								} else if para.name != "_" {
									name = para.name
								} else {
									name = "$\(index)"
								}
								return """
										"\(name)": String(data: try encoder.encode(_\(index)), encoding: .utf8)
							"""
							}).joined(separator: ",\n"))
									]
								])
							"""
							encodings.append(code)
						}
					}
				}
			}
			decode =
				"""
			init(from decoder: Decoder) throws {
				let container = try decoder.singleValueContainer()
				let content = try container.decode([String: [String: String]].self)
				let error = DecodingError.typeMismatch(\(definitionObject.name).self, DecodingError.Context(codingPath: [], debugDescription: ""))
				guard let name = content.keys.first else {
					throw error
				}
				let decoder = JSONDecoder()
				switch name {
			\(indent: 2, decodings.joined(separator: "\n"))
				default:
					throw error
				}
			}
			"""
			
			encode =
				"""
			func encode(to encoder: Encoder) throws {
				var container = encoder.singleValueContainer()
				let encoder = JSONEncoder()
				switch self {
			\(indent: 2, encodings.joined(separator: "\n"))
				}
			}
			"""
		}
		
		func generatedEnumBaseRawValue() {
			decode = """
			// \(definitionObject.name) is base on RawRepresentable
			// should not use HappyDecodableEnum
			
			"""
			
			encode =
				"""
			// \(definitionObject.name) is base on RawRepresentable
			// should not use HappyEncodableEnum
			"""
		}
		
		if definitionObject.type == .enum {
			if Set(inheritedtypes).intersection(rawRepresentableRawValues).isEmpty {
				generatedEnum()
			} else {
				generatedEnumBaseRawValue()
			}
		} else {
			generatedType()
		}
		
		
		let code =
			"""
		extension \(definitionObject.name) {
		\(indent: 1, (customCodingKeys == nil).add(CodingKeys) )
		\(indent: 1, isConfirmToDecodable.add(decode))
		\(indent: 1, isConfirmToEncodable.add(encode))
		}
		""".replacingOccurrences(of: "\n\n", with: "\n")
		
		return code
	}
}
