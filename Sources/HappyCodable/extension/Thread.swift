//
//  Thread.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/9/21.
//

import Foundation
import Darwin

extension Thread {
	private struct ThreadDictionaryKey {
		static let decoder: String = "HappyCodable.codingKeys.decoder.key"
		static let encoder: String = "HappyCodable.codingKeys.encoder.key"
		static let attributeEncoder: String = "HappyCodable.codingKeys.attributeEncoder.key"
	}
	
	static var attributeEncoder: ModelAttributeEncoder? {
		get {
			current.threadDictionary[ThreadDictionaryKey.encoder] as? ModelAttributeEncoder
		}
		set {
			current.threadDictionary[ThreadDictionaryKey.encoder] = newValue
		}
	}
	
	/// decode时记录处理的property wrapper的栈, 用数组是为了防止递归
	@usableFromInline
	static var decoder: (() -> __JSONDecoder?)? {
		get {
			current.threadDictionary[ThreadDictionaryKey.decoder] as? (() -> __JSONDecoder?)
		}
		set {
			current.threadDictionary[ThreadDictionaryKey.decoder] = newValue
		}
	}
	/// 根据类型保存所有 alterCodingKeys, 操作时需要保证线程安全
	
	struct AllModelCache {
		private static var _allModelCache = [ObjectIdentifier: ModelCache]()
		/// 操作 allModelCache 用到的锁
		private static var cacheLock = DispatchSemaphore(value: 1)
		static subscript(_ key: Any.Type) -> ModelCache? {
			get {
				cacheLock.wait()
				defer {
					cacheLock.signal()
				}
				return _allModelCache[.init(key)]
			}
			set {
				cacheLock.wait()
				defer {
					cacheLock.signal()
				}
				_allModelCache[.init(key)] = newValue
			}
		}
	}
	
}
