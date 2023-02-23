//
//  File.swift
//  
//
//  Created by 庄黛淳华 on 2023/2/23.
//

import Foundation

extension CodingKey {
	func parseGenericTypeAttribute<R: GenericTypeAttribute>(for type: R.Type, with decoder: __JSONDecoder) throws -> R? {
		let container = try decoder.container(keyedBy: Self.self)

		return try type.decode(container: container, forKey: self)
	}
}
