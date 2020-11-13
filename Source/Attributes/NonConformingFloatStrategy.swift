//
//  NonConformingFloatStrategy.swift
//  Pods
//
//  Created by 庄黛淳华 on 2020/9/22.
//

import Foundation

extension Happy {
	@propertyWrapper
	final public class nonConformingFloatStrategy<Float: BinaryFloatingPoint & Codable & LosslessStringConvertible> {
		let encodeStrategy: Foundation.JSONEncoder.NonConformingFloatEncodingStrategy
		let decodeStrategy: Foundation.JSONDecoder.NonConformingFloatDecodingStrategy
		var storage: Float?
		var constructor: (() -> Float)?
		
		public var wrappedValue: Float {
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
		public init(wrappedValue constructor: @escaping @autoclosure () -> Float, decode: Foundation.JSONDecoder.NonConformingFloatDecodingStrategy = .throw, encode: Foundation.JSONEncoder.NonConformingFloatEncodingStrategy = .throw) {
			self.constructor = constructor
			self.encodeStrategy = encode
			self.decodeStrategy = decode
		}
		
		init(value: Float?, attribute: ModelCache.NonConformingFloatStrategy<Float>?) {
			self.storage = value
			self.constructor = attribute?.defaultValue
			self.encodeStrategy = attribute?.encode ?? .throw
			self.decodeStrategy = attribute?.decode ?? .throw
		}
	}
}

extension Happy.nonConformingFloatStrategy: GenericTypeAttribute {
	
}
extension Happy.nonConformingFloatStrategy: Hashable {
	public static func == (lhs: Happy.nonConformingFloatStrategy<Float>, rhs: Happy.nonConformingFloatStrategy<Float>) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(wrappedValue)
	}
}

// MARK: - 这一块修改自原生, 除非增加了strategy 否则一般都不需要改 https://github.com/apple/swift/blob/88b093e9d77d6201935a2c2fb13f27d961836777/stdlib/public/Darwin/Foundation/JSONEncoder.swift
extension Happy.nonConformingFloatStrategy: Codable {
	public convenience init(from decoder: Decoder) throws {
		fatalError()
	}
	
	public func encode(to encoder: Encoder) throws {
		guard !wrappedValue.isInfinite && !wrappedValue.isNaN else {
			guard case let .convertToString(posInfString, negInfString, nanString) = encodeStrategy else {
				throw EncodingError._invalidFloatingPointValue(wrappedValue, at: encoder.codingPath)
			}
			
			if wrappedValue == Float.infinity {
				return try String(posInfString).encode(to: encoder)
			} else if wrappedValue == -Float.infinity {
				return try String(negInfString).encode(to: encoder)
			} else {
				return try String(nanString).encode(to: encoder)
			}
		}
		
		return try wrappedValue.encode(to: encoder)
	}
}

// MARK: - 以下修改自原生, 除非增加了strategy 否则一般都不需要改 https://github.com/apple/swift/blob/88b093e9d77d6201935a2c2fb13f27d961836777/stdlib/public/Darwin/Foundation/JSONEncoder.swift
extension KeyedDecodingContainer {
	public func decode<Float>(_ type: Happy.nonConformingFloatStrategy<Float>.Type, forKey key: Key) throws -> Happy.nonConformingFloatStrategy<Float> {
		guard
			let decoder = Thread.decoder?(),
			let attribute = decoder.dealingModel.decodeAttributes[key.stringValue] as? ModelCache.NonConformingFloatStrategy<Float>
		else {
			return .init(value: Float(try decode(Double.self, forKey: key)), attribute: nil)
		}
		
		switch attribute.decode {
		case .throw:
			if contains(key) {
				return .init(value: Float(try decode(Double.self, forKey: key)), attribute: attribute)
			} else {
				return .init(value: nil, attribute: attribute)
			}
		case let .convertFromString(posInfString, negInfString, nanString):
			var float: Float?
			if let string = try? decode(String.self, forKey: key) {
				if string == posInfString {
					float = Float.infinity
				}
				if string == negInfString {
					float = -Float.infinity
				}
				if string == nanString {
					float = Float.nan
				}
				if let _float = Float(string) {
					float = _float
				}
			}
			if float == nil, let _float = try? decode(Double.self, forKey: key) {
				float = Float(_float)
			}
			return .init(value: float, attribute: attribute)
		}
	}
}

extension KeyedEncodingContainer {
	public mutating func encode<T>(_ value: Happy.nonConformingFloatStrategy<T>, forKey key: Key) throws {
		if let encoder = Thread.attributeEncoder {
			encoder.cachingModel.decodeAttributes[key.stringValue] = ModelCache.NonConformingFloatStrategy(encode: value.encodeStrategy, decode: value.decodeStrategy, defaultValue: value.constructor)
			return
		}
		try encode(RedirectCodable(direct: value), forKey: key)
	}
}
