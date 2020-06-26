//
//  KeyedDecodingContainer.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation

extension KeyedDecodingContainer {
	@inline(__always)
	public func decode<V>(defaultValue: Bool?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Bool {
		var lastSuccessVaule: Bool?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Bool.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Bool.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else if case .typeMismatch = error {
						if V.self is HappyCodableOptional.Type {
							if let value = try? self.decodeIfPresent(Int.self, forKey: key) {
								lastSuccessVaule = value == 1
							}
						} else if let value = try? self.decode(Int.self, forKey: key) {
							lastSuccessVaule = value == 1
						} else {
							// 能找到这个key, 但是解析错误
							lastNotKeyMissingError = error
						}
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Bool.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Bool value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: String?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> String {
		var lastSuccessVaule: String?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(String.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(String.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected String value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: Double?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Double {
		var lastSuccessVaule: Double?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Double.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Double.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Double.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Double value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: Float?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Float {
		var lastSuccessVaule: Float?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Float.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Float.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Float.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Float value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: Int?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Int {
		var lastSuccessVaule: Int?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Int.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Int.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Int.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Int value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: Int8?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Int8 {
		var lastSuccessVaule: Int8?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Int8.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Int8.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Int8.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Int8 value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: Int16?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Int16 {
		var lastSuccessVaule: Int16?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Int16.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Int16.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Int16.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Int16 value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: Int32?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Int32 {
		var lastSuccessVaule: Int32?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Int32.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Int32.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Int32.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Int32 value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: Int64?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> Int64 {
		var lastSuccessVaule: Int64?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(Int64.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(Int64.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(Int64.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected Int64 value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: UInt?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> UInt {
		var lastSuccessVaule: UInt?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(UInt.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(UInt.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(UInt.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected UInt value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: UInt8?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> UInt8 {
		var lastSuccessVaule: UInt8?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(UInt8.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(UInt8.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(UInt8.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected UInt8 value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: UInt16?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> UInt16 {
		var lastSuccessVaule: UInt16?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(UInt16.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(UInt16.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(UInt16.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected UInt16 value but found nothing."))
		}
	}

	@inline(__always)
	public func decode<V>(defaultValue: UInt32?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> UInt32 {
		var lastSuccessVaule: UInt32?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(UInt32.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(UInt32.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(UInt32.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected UInt32 value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<V>(defaultValue: UInt64?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> UInt64 {
		var lastSuccessVaule: UInt64?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(UInt64.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(UInt64.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(UInt64.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected UInt64 value but found nothing."))
		}
	}
	
	@inline(__always)
	public func decode<T, V>(defaultValue: T?, verifyValue: V, forKey keys: KeyedDecodingContainer<K>.Key...) throws -> T where T: Decodable {
		var lastSuccessVaule: T?
		var lastNotKeyMissingError: DecodingError?
		// 因为有些使用Codable的第三方框架是依赖于所有key对应的类型的, 所以这里得遍历一遍keys
		for key in keys {
			do {
				if V.self is HappyCodableOptional.Type {
					if let value = try self.decodeIfPresent(T.self, forKey: key) {
						lastSuccessVaule = value
					}
				} else {
					lastSuccessVaule = try self.decode(T.self, forKey: key)
				}
			} catch {
				if let error = error as? DecodingError {
					if case .keyNotFound = error {
						
					} else {
						// 能找到这个key, 但是解析错误
						lastNotKeyMissingError = error
					}
				}
			}
		}
		if let value = lastSuccessVaule {
			return value
		} else if let error = lastNotKeyMissingError {
			throw error
		} else {
			throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: keys, debugDescription: "Expected T value but found nothing."))
		}
	}
}
