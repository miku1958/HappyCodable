//
//  DateStrategy.swift
//  Pods
//
//  Created by 庄黛淳华 on 2020/9/22.
//

import Foundation

extension Happy {
	@propertyWrapper
	final public class dateStrategy {
		let encodeStrategy: Foundation.JSONEncoder.DateEncodingStrategy
		let decodeStrategy: Foundation.JSONDecoder.DateDecodingStrategy
		var storage: Date?
		var constructor: (() -> Date)?
		
		public var wrappedValue: Date {
			get {
				if let value = storage {
					return value
				}
				storage = constructor!()
				return storage!
			}
			set {
				storage = newValue
			}
		}
		public init(wrappedValue constructor: @escaping @autoclosure () -> Date, decode: Foundation.JSONDecoder.DateDecodingStrategy = .deferredToDate, encode: Foundation.JSONEncoder.DateEncodingStrategy = .deferredToDate)  {
			self.constructor = constructor
			self.encodeStrategy = encode
			self.decodeStrategy = decode
		}
		
		init(_ wrappedValue: Date, decode: Foundation.JSONDecoder.DateDecodingStrategy, encode: Foundation.JSONEncoder.DateEncodingStrategy)  {
			self.storage = wrappedValue
			self.encodeStrategy = encode
			self.decodeStrategy = decode
		}
	}
}

extension Happy.dateStrategy: GenericTypeAttribute {

}
extension Happy.dateStrategy: Hashable {
	public static func == (lhs: Happy.dateStrategy, rhs: Happy.dateStrategy) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(wrappedValue)
	}
}

// MARK: - 这一块修改自原生, 除非增加了strategy 否则一般都不需要改 https://github.com/apple/swift/blob/88b093e9d77d6201935a2c2fb13f27d961836777/stdlib/public/Darwin/Foundation/JSONEncoder.swift
extension Happy.dateStrategy: Codable {
	public convenience init(from decoder: Decoder) throws {
		fatalError()
	}

	public func encode(to encoder: Encoder) throws {
		switch encodeStrategy {
		case .deferredToDate:
			// Must be called with a surrounding with(pushedKey:) call.
			// Dates encode as single-value objects; this can't both throw and push a container, so no need to catch the error.
			try wrappedValue.encode(to: encoder)
		case .secondsSince1970:
			try wrappedValue.timeIntervalSince1970.encode(to: encoder)
		case .millisecondsSince1970:
			try (1000.0 * wrappedValue.timeIntervalSince1970).encode(to: encoder)
		case .iso8601:
			if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
				try _iso8601Formatter.string(from: wrappedValue).encode(to: encoder)
			} else {
				fatalError("ISO8601DateFormatter is unavailable on this platform.")
			}
		case .formatted(let formatter):
			try formatter.string(from: wrappedValue).encode(to: encoder)
		case .custom(let closure):
			try closure(wrappedValue, encoder)
		}
	}
}

// MARK: - 以下修改自原生, 除非增加了strategy 否则一般都不需要改 https://github.com/apple/swift/blob/88b093e9d77d6201935a2c2fb13f27d961836777/stdlib/public/Darwin/Foundation/JSONEncoder.swift
extension KeyedDecodingContainer {
	public func decode(_ type: Happy.dateStrategy.Type, forKey key: Key) throws -> Happy.dateStrategy {
		guard
			let decoder = Thread.decoder?(),
			let attribute = decoder.dealingModel.decodeAttributes[key.stringValue] as? ModelCache.DateStrategy
			else {
				return .init(try decode(Date.self, forKey: key), decode: .deferredToDate, encode: .deferredToDate)
		}
		let date: Date
		switch attribute.decode {
		case .deferredToDate:
			date = try decode(Date.self, forKey: key)
		case .secondsSince1970:
			date = Date(timeIntervalSince1970: try decode(TimeInterval.self, forKey: key))
		case .millisecondsSince1970:
			date = Date(timeIntervalSince1970: try decode(TimeInterval.self, forKey: key) / 1000.0)
		case .iso8601:
			if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
				let string = try decode(String.self, forKey: key)
				guard let _date = _iso8601Formatter.date(from: string) else {
					throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
				}
				
				date = _date
			} else {
				fatalError("ISO8601DateFormatter is unavailable on this platform.")
			}
		case .formatted(let formatter):
			let string = try decode(String.self, forKey: key)
			guard let _date = formatter.date(from: string) else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Date string does not match format expected by formatter."))
			}
			
			date = _date
			
		case .custom(let closure):
			date = try closure(decoder)
		}
		return .init(date, decode: attribute.decode, encode: attribute.encode)
	}
}

// MARK: - KeyedEncodingContainer
extension KeyedEncodingContainer {
	public mutating func encode(_ value: Happy.dateStrategy, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DateStrategy(encode: value.encodeStrategy, decode: value.decodeStrategy, defaultValue: value.constructor)
			return
		}
		try encode(RedirectCodable(direct: value), forKey: key)
	}
}
