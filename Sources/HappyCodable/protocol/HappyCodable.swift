//
//  HappyCodable.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/5/23.
//

import Foundation
public struct HappyCodableDecodeOption {
	let errorsReporter: ((Error) -> Void)?
	
	/// initializer
	/// - Parameter errorsCatcher: 用于捕获转码时出现的 error, 如果为 nil 则强制使用默认值
	public init(errorsReporter: ((Error) -> Void)? = nil) {
		self.errorsReporter = errorsReporter
	}
}
// MARK: - HappyCodableSerialization
public protocol HappyCodableSerialization {
	
}

// MARK: - Type
// MARK: - HappyEncodable
public protocol HappyCodable: Encodable, Decodable {
	init()
	mutating func didFinishMapping()
	static var decodeOption: HappyCodableDecodeOption { get }
}

extension HappyCodable {
	public func didFinishMapping() { }
}

extension HappyCodable {
	static func defaultModelEncodeJSON() -> [String: Any] {
		do {
			let json = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self.init()), options: .allowFragments)
			return json as? [String: Any] ?? [:]
		} catch {
			return [:]
		}
	}
}
