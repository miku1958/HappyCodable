//
//  CodableItem.swift
//  HappyCodable
//
//

import Foundation

struct CodableItem {
	let name: String
	enum TypeSyntax {
		case normal(String)
		case optional(String)
		var isOptional: Bool {
			if case .optional = self {
				return true
			} else {
				return false
			}
		}
		var string: String {
			switch self {
			case let .normal(string):
				return string
			case let .optional(string):
				return string
			}
		}
	}

	let defaultValue: String?
	var alterKeys: [String] = []
	var uncoding: Bool = false

	struct DateStrategy {
		let encode: String
		let decode: String
	}
	var dateStrategy: DateStrategy?

	struct DataStrategy {
		let encode: String
		let decode: String
	}
	var dataStrategy: DataStrategy?

	struct NonConformingFloatStrategy {
		let encode: String
		let decode: String
	}
	var nonConformingFloatStrategy: NonConformingFloatStrategy?

	var elementNullable: Bool = false
}

extension CodableItem {
	func codingKey(override: [String: String]) -> String? {
		if uncoding {
			return nil
		}
		return "case \(name) = \"\(override[name] ?? name)\""
	}

	var decode: String {
		if uncoding {
			// swiftlint:disable force_unwrapping
			return "self.\(name) = \(defaultValue!)"
			// swiftlint:enable force_unwrapping
		}
		let alterKeysArgument: String
		if alterKeys.isEmpty {
			alterKeysArgument = ""
		} else {
			alterKeysArgument = ", alterKeys: { [\(alterKeys.joined(separator: ","))] }"
		}

		let additionalArgument: String
		if let dataStrategy {
			additionalArgument = ", strategy: \(dataStrategy.decode)"
		} else if let dateStrategy {
			additionalArgument = ", strategy: \(dateStrategy.decode)"
		} else if let nonConformingFloatStrategy {
			additionalArgument = ", strategy: \(nonConformingFloatStrategy.decode)"
		} else if elementNullable {
			additionalArgument = ", strategy: ()"
		} else {
			additionalArgument = ""
		}

		let decodeExpression = "container.decode(key: CodingKeys.\(name).rawValue \(alterKeysArgument) \(additionalArgument))"

		func throwIfNoDefaultValue() -> String {
			if let defaultValue {
				return """
				errors.append(error)
				return \(defaultValue)
				"""
			} else {
				return "throw error"
			}
		}

		return """
		self.\(name) = \(defaultValue == nil ? "try " : ""){
			do {
				return try \(decodeExpression)
			} catch {
				\(throwIfNoDefaultValue())
			}
		}()
		"""
	}

	var encode: String {
		if uncoding {
			return ""
		}

		let additionalArgument: String
		if let dataStrategy {
			additionalArgument = ", strategy: \(dataStrategy.encode)"
		} else if let dateStrategy {
			additionalArgument = ", strategy: \(dateStrategy.encode)"
		} else if let nonConformingFloatStrategy {
			additionalArgument = ", strategy: \(nonConformingFloatStrategy.encode)"
		} else {
			additionalArgument = ""
		}

		let decodeExpression = "container.encodeIfPresent(self.\(name), forKey: CodingKeys.\(name).rawValue \(additionalArgument))"

		return """
		do {
			try \(decodeExpression)
		} catch {
			errors.append(error)
		}
		"""
	}
}
