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
		static let attributeEncoder: String = "HappyCodable.codingKeys.attributeEncoder.key"
	}
	
	static var attributeEncoder: ModelAttributeEncoder? {
		get {
			current.threadDictionary[ThreadDictionaryKey.decoder] as? ModelAttributeEncoder
		}
		set {
			current.threadDictionary[ThreadDictionaryKey.decoder] = newValue
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
	@usableFromInline
	static var allModelCache = [ObjectIdentifier: ModelCache]()
	
	/// 操作 allModelCache 用到的递归锁
	
	private static var cacheLock: pthread_mutex_t = {
		var lock = pthread_mutex_t()
		var attr = pthread_mutexattr_t()
		pthread_mutexattr_init(&attr)
		pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
		pthread_mutex_init(&lock, &attr)
		return lock
	}()
	
	@inline(__always)
	static func wait() {
		pthread_mutex_lock(&cacheLock)
	}
	
	@inline(__always)
	static func signal() {
		pthread_mutex_unlock(&cacheLock)
	}
}
