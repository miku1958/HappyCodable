//
//  File.swift
//  HappyCodable
//
//  Created by 庄黛淳华 on 2020/6/17.
//

import Foundation
import SourceKittenFramework

extension SourceKittenFramework.File {
	var cacheFolder: URL? {
		guard let path = path else { return nil }
		let folder = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("HappyCodable").appendingPathComponent(path.md5())
		return folder
	}
	
	var fileMD5: String? {
		guard
			let path = path,
			let attributes = try? FileManager.default.attributesOfItem(atPath: path)
			else { return nil }
		var checkString = version
		checkString.append(contentsOf: ".")
		if let date = attributes[.modificationDate] as? Date {
			checkString.append(contentsOf: "\(date.timeIntervalSince1970)")
		}
		return checkString.md5()
	}
	func contents(from offset: Int) -> String? {
		let utf8Content = contents.utf8
		return String(utf8Content[utf8Content.index(utf8Content.startIndex, offsetBy: offset)...])
	}
}
