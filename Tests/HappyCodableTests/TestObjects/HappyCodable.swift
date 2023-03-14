//
//  HappyCodable.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

extension HappyEncodable {
	public static var encodeHelper: EncodeHelper {
		.init()
	}
}

extension HappyDecodable {
	public static var decodeHelper: DecodeHelper {
		#if DEBUG1
		return .init { error in
			print(error)
		}
		#else
		return .init()
		#endif
	}
}
