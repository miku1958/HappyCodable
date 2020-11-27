//
//  HappyCodable.swift
//  Demo
//
//  Created by 庄黛淳华 on 2020/11/27.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

extension HappyCodable {
	public static var decodeOption: HappyCodableDecodeOption {
		#if DEBUG1
		return .init { (error) in
			print(error)
		}
		#else
		return .init()
		#endif
	}
}
