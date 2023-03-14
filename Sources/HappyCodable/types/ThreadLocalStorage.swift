//
//  ThreadLocalStorage.swift
//  HappyCodable
//
//

// modified from https://github.com/nvzqz/Threadly
import Foundation

@propertyWrapper
class ThreadLocalStorage<V> {
	private final class Box<Value> {
		/// The boxed value.
		var value: Value

		/// Creates an instance that boxes `value`.
		init(_ value: Value) {
			self.value = value
		}
	}

	private var raw: pthread_key_t

	private var box: Box<V> {
		guard let pointer = pthread_getspecific(raw) else {
			let box = Box(initialValue)
			pthread_setspecific(raw, Unmanaged.passRetained(box).toOpaque())
			return box
		}
		return Unmanaged<Box<V>>.fromOpaque(pointer).takeUnretainedValue()
	}

	let initialValue: V
	var wrappedValue: V {
		get {
			box.value
		}
		set {
			box.value = newValue
		}
	}

	init(wrappedValue: V) {
		raw = pthread_key_t()
		pthread_key_create(&raw) {
			// Cast required because argument is optional on some
			// platforms (Linux) but not on others (macOS)
			guard let rawPointer = ($0 as UnsafeMutableRawPointer?) else {
				return
			}
			Unmanaged<AnyObject>.fromOpaque(rawPointer).release()
		}
		initialValue = wrappedValue
	}

	deinit {
		pthread_key_delete(raw)
	}
}
