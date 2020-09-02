//
//  SingleValueDecodingContainer.swift
//  HappyCodable-Common
//
//  Created by 庄黛淳华 on 2020/8/1.
//

#if canImport(Foundation)
import Foundation
#endif

extension SingleValueDecodingContainer {
	public func decodeSafe() throws -> String {
		do {
			return try decode(String.self)
		} catch {
			guard case DecodingError.typeMismatch = error else {
				throw error
			}
			if let value = try? decode(Bool.self) {
				return String(value)
			} else if let value = try? decode(Int64.self) {
				return String(value)
			} else if let value = try? decode(UInt64.self) {
				return String(value)
			} else if let value = try? decode(Double.self) {
				return String(value)
			} else {
				throw error
			}
		}
	}
	public func decodeSafe<T>() throws -> T where T: BinaryFloatingPoint {
		func convert(_ value: Double) -> T {
			value as? T ?? T(value)
		}
		do {
			return convert(try decode(Double.self))
		} catch {
			guard case DecodingError.typeMismatch = error else {
				throw error
			}
			
			if let value = try? decode(String.self), let result = Double(value) {
				return convert(result)
			} else {
				throw error
			}
		}
	}
	public func decodeSafe<T>() throws -> T where T: FixedWidthInteger & SignedInteger & Decodable {
		func boundsCheck(value: Int64) throws -> T {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return T(value)
		}
		do {
			return try boundsCheck(value: try decode(Int64.self))
		} catch {
			guard case DecodingError.typeMismatch = error else {
				throw error
			}
			if let value = try? decode(String.self), let result = Int64(value) {
				return try boundsCheck(value: result)
			} else {
				throw error
			}
		}
	}
	public func decodeSafe<T>() throws -> T where T: FixedWidthInteger & UnsignedInteger & Decodable {
		func boundsCheck(value: UInt64) throws -> T {
			guard value <= T.max, value >= T.min else {
				throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Parsed JSON number <\(value)> does not fit in \(T.self)."))
			}
			return T(value)
		}
		do {
			return try boundsCheck(value: try decode(UInt64.self))
		} catch {
			guard case DecodingError.typeMismatch = error else {
				throw error
			}
			if let value = try? decode(String.self), let result = UInt64(value) {
				return try boundsCheck(value: result)
			} else {
				throw error
			}
		}
	}
}
