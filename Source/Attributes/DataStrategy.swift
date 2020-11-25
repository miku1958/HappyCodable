//
//  DataStrategy.swift
//  Pods
//
//  Created by 庄黛淳华 on 2020/9/22.
//

import Foundation

extension Happy {
	@propertyWrapper
	final public class dataStrategy {
		let decodeStrategy: Foundation.JSONDecoder.DataDecodingStrategy
		let encodeStrategy: Foundation.JSONEncoder.DataEncodingStrategy
		var storage: Data?
		var constructor: (() -> Data)?
		
		public var wrappedValue: Data {
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
		public init(wrappedValue constructor: @escaping @autoclosure () -> Data, decode: Foundation.JSONDecoder.DataDecodingStrategy = .deferredToData, encode: Foundation.JSONEncoder.DataEncodingStrategy = .deferredToData)  {
			self.constructor = constructor
			self.decodeStrategy = decode
			self.encodeStrategy = encode
		}
		
		init(_ wrappedValue: Data, decode: Foundation.JSONDecoder.DataDecodingStrategy = .deferredToData, encode: Foundation.JSONEncoder.DataEncodingStrategy = .deferredToData)  {
			self.storage = wrappedValue
			self.decodeStrategy = decode
			self.encodeStrategy = encode
		}
	}
}

extension Happy.dataStrategy: GenericTypeAttribute {
	
}
extension Happy.dataStrategy: Hashable {
	public static func == (lhs: Happy.dataStrategy, rhs: Happy.dataStrategy) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(wrappedValue)
	}
}

// MARK: - 这一块修改自原生, 除非增加了strategy 否则一般都不需要改 https://github.com/apple/swift/blob/88b093e9d77d6201935a2c2fb13f27d961836777/stdlib/public/Darwin/Foundation/JSONEncoder.swift
extension Happy.dataStrategy: Codable {
	public convenience init(from decoder: Decoder) throws {
		fatalError()
	}
	
	public func encode(to encoder: Encoder) throws {
		switch encodeStrategy {
		case .deferredToData:
			try wrappedValue.encode(to: encoder)
		case .base64:
			try wrappedValue.base64EncodedString().encode(to: encoder)
		case .custom(let closure):
			try closure(wrappedValue, encoder)
		}
	}
}

// MARK: - 以下修改自原生, 除非增加了strategy 否则一般都不需要改 https://github.com/apple/swift/blob/88b093e9d77d6201935a2c2fb13f27d961836777/stdlib/public/Darwin/Foundation/JSONEncoder.swift
// MARK: - KeyedDecodingContainer
extension KeyedDecodingContainer {
	public func decode(_ type: Happy.dataStrategy.Type, forKey key: Key) throws -> Happy.dataStrategy {
		guard
			let decoder = Thread.decoder?(),
			let attribute = decoder.dealingModel.decodeAttributes[key.stringValue] as? ModelCache.DataStrategy
			else {
				return .init(try decode(Data.self, forKey: key), decode: .deferredToData, encode: .deferredToData)
		}
		let data: Data
		do {
			switch attribute.decode {
			case .deferredToData:
				data = try decode(Data.self, forKey: key)
			case .base64:
				guard let _data = Data(base64Encoded: try decode(String.self, forKey: key)) else {
					throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encountered Data is not valid Base64."))
				}
				data = _data
			case .custom(let closure):
				let sentinel = decoder.pushStorage(key.stringValue)
				defer { decoder.popStorage(sentinel) }
				data = try closure(decoder)
			}
		} catch {
			data = attribute.defaultValue!()
		}
		return .init(data, decode: attribute.decode, encode: attribute.encode)
	}
}

// MARK: - KeyedEncodingContainer
extension KeyedEncodingContainer {
	public mutating func encode(_ value: Happy.dataStrategy, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.DataStrategy(encode: value.encodeStrategy, decode: value.decodeStrategy, defaultValue: value.constructor)
			return
		}
		try encode(RedirectCodable(direct: value), forKey: key)
	}
}
