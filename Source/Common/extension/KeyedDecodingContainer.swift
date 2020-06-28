//
//  KeyedDecodingContainer.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation

extension Decoder {
	@inline(__always)
	public func decode<T, V, K>(defaultValue: T?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> T where T: Decodable {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(T.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected T value but found nothing."))
				}
			} else {
				return try container.decode(T.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(T.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(T.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Bool?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Bool {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Bool.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Bool.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Bool value but found nothing."))
				}
			} else {
				return try container.decode(Bool.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Bool.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Bool.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			if case DecodingError.typeMismatch = error {
				if V.self is HappyCodableOptional.Type {
					if let value = try? container.decodeIfPresent(Int.self, forKey: key) {
						return value == 1
					}
				} else if let value = try? container.decode(Int.self, forKey: key) {
					return value == 1
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: String?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> String {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(String.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected String value but found nothing."))
				}
			} else {
				return try container.decode(String.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(String.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(String.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Double?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Double {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Double.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Double.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Double value but found nothing."))
				}
			} else {
				return try container.decode(Double.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Double.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Double.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Float?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Float {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Float.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Float.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Float value but found nothing."))
				}
			} else {
				return try container.decode(Float.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Float.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Float.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Int?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Int {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Int.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Int.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Int value but found nothing."))
				}
			} else {
				return try container.decode(Int.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Int.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Int.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Int8?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Int8 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Int8.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Int8.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Int8 value but found nothing."))
				}
			} else {
				return try container.decode(Int8.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Int8.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Int8.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Int16?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Int16 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Int16.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Int16.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Int16 value but found nothing."))
				}
			} else {
				return try container.decode(Int16.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Int16.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Int16.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Int32?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Int32 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Int32.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Int32.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Int32 value but found nothing."))
				}
			} else {
				return try container.decode(Int32.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Int32.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Int32.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: Int64?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> Int64 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(Int64.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(Int64.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected Int64 value but found nothing."))
				}
			} else {
				return try container.decode(Int64.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(Int64.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(Int64.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: UInt?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> UInt {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(UInt.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(UInt.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected UInt value but found nothing."))
				}
			} else {
				return try container.decode(UInt.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(UInt.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(UInt.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: UInt8?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> UInt8 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(UInt8.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(UInt8.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected UInt8 value but found nothing."))
				}
			} else {
				return try container.decode(UInt8.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(UInt8.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(UInt8.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: UInt16?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> UInt16 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(UInt16.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(UInt16.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected UInt16 value but found nothing."))
				}
			} else {
				return try container.decode(UInt16.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(UInt16.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(UInt16.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: UInt32?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> UInt32 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(UInt32.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(UInt32.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected UInt32 value but found nothing."))
				}
			} else {
				return try container.decode(UInt32.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(UInt32.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(UInt32.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
	@inline(__always)
	public func decode<V, K>(defaultValue: UInt64?, verifyValue: V, forKey key: KeyedDecodingContainer<K>.Key, alterKeys: @autoclosure () -> [String], from: KeyedDecodingContainer<K>?) throws -> UInt64 {
		let container: KeyedDecodingContainer<K>
		if let from = from {
			container = from
		} else {
			container = try self.container(keyedBy: K.self)
		}
		do {
			if V.self is HappyCodableOptional.Type {
				if let value = try container.decodeIfPresent(UInt64.self, forKey: key) {
					return value
				} else {
					throw DecodingError.valueNotFound(UInt64.self, DecodingError.Context(codingPath: [key], debugDescription: "Expected UInt64 value but found nothing."))
				}
			} else {
				return try container.decode(UInt64.self, forKey: key)
			}
		} catch {
			let alterKeys = alterKeys()
			if !alterKeys.isEmpty {
				let container = try self.container(keyedBy: StringCodingKey.self)
				for keyStr in alterKeys {
					let key = StringCodingKey(keyStr)
					do {
						if V.self is HappyCodableOptional.Type {
							if let value = try container.decodeIfPresent(UInt64.self, forKey: key) {
								return value
							}
						} else {
							return try container.decode(UInt64.self, forKey: key)
						}
					} catch {
		
					}
				}
			}
			throw error
		}
	}
			
}