//
//  ExtensionFileCreator.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/28.
//

import Foundation

private extension Bool {
	func add(_ string: String) -> String {
		self ? "\(string)" : ""
	}
}
let tab = Character(UnicodeScalar(9))
let newline = Character(UnicodeScalar(10))
extension String.StringInterpolation {
	fileprivate mutating func appendInterpolation<S>(indent count: Int, _ content: S) where S: StringProtocol {
		var lines = content.split(separator: newline).map({ String($0) })
		for index in 0..<lines.count {
			lines[index] = String(Array(repeating: tab, count: count)) + lines[index]
		}

		appendLiteral(lines.joined(separator: String(newline)))
	}
}

createKeyedDecodingContainer()

func createKeyedDecodingContainer() {
	let genericTypes = [
		"T"
	]
	let types = [
		"T",
		"Bool",
		"String",
		"Double",
		"Float",
		"Int",
		"Int8",
		"Int16",
		"Int32",
		"Int64",
		"UInt",
		"UInt8",
		"UInt16",
		"UInt32",
		"UInt64"
	]
	let errorHandler = [
		"Bool":
		"""
		if case DecodingError.typeMismatch = error {
			if V.self is HappyCodableOptional.Type {
				if let value = try? container.decodeIfPresent(Int.self, forKey: key) {
					return value == 1
				}
			} else if let value = try? container.decode(Int.self, forKey: key) {
				return value == 1
			}
		}
		"""
	]
	let functions = types.map({
		let isGeneric = genericTypes.contains($0)
		return """
		@inline(__always)
		public func decode<\(isGeneric.add("\($0), "))V, K>(defaultValue: \($0)?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> \($0) \(isGeneric.add("where \($0): Decodable ")){
			let container: KeyedDecodingContainer<K>
			if let from = from {
				container = from
			} else {
				container = try self.container(keyedBy: K.self)
			}
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try container.decodeIfPresent(\($0).self, forKey: key) {
						return value
					} else {
						throw DecodingError.valueNotFound(\($0).self, DecodingError.Context(codingPath: [key], debugDescription: "Expected \($0) value but found nothing."))
					}
				} else {
					return try container.decode(\($0).self, forKey: key)
				}
			} catch {
		\((!isGeneric && $0 != "String").add("""
				if let value = try? container.decodeIfPresent(String.self, forKey: key), let result = \($0)(value) {
					return result
				}
		"""))
				let alterKeys = alterKeys()
				if !alterKeys.isEmpty {
					let container = try self.container(keyedBy: StringCodingKey.self)
					for keyStr in alterKeys {
						let key = StringCodingKey(keyStr)
						do {
							if V.self is HappyCodableOptional.Type {
								if let value = try container.decodeIfPresent(\($0).self, forKey: key) {
									return value
								}
							} else {
								return try container.decode(\($0).self, forKey: key)
							}
						} catch {
		\((!isGeneric && $0 != "String").add("""
							if let value = try? container.decodeIfPresent(String.self, forKey: key), let result = \($0)(value) {
								return result
							}
		"""))
						}
					}
				}
		\(indent: 2, errorHandler["\($0)"] ?? "")
				throw error
			}
		}
				
		"""
	}).joined(separator: String(newline))
	let code = """
	//
	//  KeyedDecodingContainer.swift
	//  HappyCodable
	//
	//  Created by 庄黛淳华 on 2020/6/17.
	//

	import Foundation

	extension Decoder {
	\(indent: 1, functions)
	}
	"""
	
	let path = URL(fileURLWithPath: FileManager.default.currentDirectoryPath) // Desktop/HappyCodable/hAppyCodableDemo
		.deletingLastPathComponent()
		.appendingPathComponent("Source")
		.appendingPathComponent("Common")
		.appendingPathComponent("extension")
		.appendingPathComponent("KeyedDecodingContainer.swift")

	try? code.write(toFile: path.path, atomically: true, encoding: .utf8)
}
