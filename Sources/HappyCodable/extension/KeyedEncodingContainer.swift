//
//  KeyedEncodingContainer.swift
//  HappyCodable
//
//

import Foundation

// MARK: - Strategy implementation
extension KeyedEncodingContainer<String> {
	@inlinable
	@inline(__always)
	public mutating func encodeIfPresent(_ data: Data?, forKey key: KeyedEncodingContainer<K>.Key, strategy: Foundation.JSONEncoder.DataEncodingStrategy) throws {
		guard let data else {
			return
		}
		switch strategy {
		case .deferredToData:
			try encode(data, forKey: key)
		case .base64:
			try encode(data.base64EncodedString(), forKey: key)
		case .custom(let closure):
			try closure(data, superEncoder(forKey: key))
		@unknown default:
			fatalError("not implemented")
		}
	}

	@inlinable
	@inline(__always)
	public mutating func encodeIfPresent(_ date: Date?, forKey key: KeyedEncodingContainer<K>.Key, strategy: Foundation.JSONEncoder.DateEncodingStrategy) throws {
		guard let date else {
			return
		}
		switch strategy {
		case .deferredToDate:
			try encode(date.timeIntervalSinceReferenceDate, forKey: key)
		case .secondsSince1970:
			try encode(date.timeIntervalSince1970, forKey: key)
		case .millisecondsSince1970:
			try encode(1000.0 * date.timeIntervalSince1970, forKey: key)
		case .iso8601:
			try encode(_iso8601Formatter.string(from: date), forKey: key)
		case .formatted(let formatter):
			try encode(formatter.string(from: date), forKey: key)
		case .custom(let closure):
			try closure(date, superEncoder(forKey: key))
		@unknown default:
			fatalError("not implemented")
		}
	}

	// copy from https://github.com/apple/swift-corelibs-foundation/blob/0ac1a34ab76f6db3196a279c2626a0e4554ff592/Sources/Foundation/JSONEncoder.swift#L465
	@inlinable
	@inline(__always)
	public mutating func encodeIfPresent<F>(_ float: F?, forKey key: KeyedEncodingContainer<K>.Key, strategy: Foundation.JSONEncoder.NonConformingFloatEncodingStrategy) throws where F: BinaryFloatingPoint & Encodable & LosslessStringConvertible {
		guard let float else {
			return
		}
		guard !float.isNaN, !float.isInfinite else {
			if case .convertToString(let posInfString, let negInfString, let nanString) = strategy {
				let string: String
				switch float {
				case F.infinity:
					string = String(posInfString)
				case -F.infinity:
					string = String(negInfString)
				default:
					// must be nan in this case
					string = String(nanString)
				}
				try encode(string, forKey: key)
				return
			}

			throw EncodingError.invalidValue(float, .init(
				codingPath: codingPath + [key],
				debugDescription: "Unable to encode \(F.self).\(float) directly in JSON."
			))
		}

		try encode(float, forKey: key)
	}
}
