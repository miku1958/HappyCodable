//
//  HappyCodable+Helper.swift
//  HappyCodable
//
//

import Foundation

public struct DecodeHelper {
	public let errorsReporter: (([Error]) -> Void)?

	/// initializer
	/// - Parameter errorsCatcher: Used to catch errors in Decodeing
	public init(errorsReporter: (([Error]) -> Void)? = nil) {
		self.errorsReporter = errorsReporter
	}
}

public struct EncodeHelper {
	public let errorsReporter: (([Error]) -> Void)?

	/// initializer
	/// - Parameter errorsCatcher: Used to catch errors in Encodeing
	public init(errorsReporter: (([Error]) -> Void)? = nil) {
		self.errorsReporter = errorsReporter
	}
}

extension HappyEncodable {
	public func willStartEncoding() { }
}

extension HappyDecodable {
	public func didFinishDecoding() { }
}
