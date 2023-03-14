// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

let path = "/Volumes/Common/HappyCodable/Tests/HappyCodableTests"

typealias Fix = (_ content: inout String, _ checkIndex: inout String.Index) -> Void

let fixs: [Fix] = [
{ (content, checkIndex) in
	let rex = /extension HappyCodable\s*?\{\n(.*)static\s+?var\s+?decodeOption\s*?:\s*? HappyCodableDecodeOption\s*?\{/
	guard let match = try? rex.firstMatch(in: content[checkIndex...]) else {
		checkIndex = content.endIndex
		return
	}
	let replacement: String =
"""
extension HappyEncodable {
	static var encodeHelper: EncodeHelper {
		.init()
	}
}

extension HappyDecodable {
\(match.1)static var decodeHelper: DecodeHelper {
"""
	content.replaceSubrange(match.range, with: replacement)

	let offset = replacement.distance(from: replacement.startIndex, to: replacement.endIndex)

	checkIndex = content.index(match.range.lowerBound, offsetBy: offset)
},

{ (content, checkIndex) in

	let cases = [
		(/Happy\.alterCodingKeys/, "HappyAlterCodingKeys"),
		(/Happy\.dataStrategy/, "HappyDataStrategy"),
		(/Happy\.nonConformingFloatStrategy/, "HappyNonConformingFloatStrategy"),
		(/Happy\.dateStrategy/, "HappyDateStrategy"),
		(/Happy\.elementNullable/, "HappyElementNullable"),
		(/Happy\.uncoding/, "HappyUncoding"),
	]

	for (rex, replacement) in cases {
		var checkIndex = checkIndex
		while let match = try? rex.firstMatch(in: content[checkIndex...]) {
			content.replaceSubrange(match.range, with: replacement)

			let offset = replacement.distance(from: replacement.startIndex, to: replacement.endIndex)
			checkIndex = content.index(match.range.lowerBound, offsetBy: offset)
		}
	}

	while let match = try? /\n[\s|\t]*?@Happy.dynamicDefault/.firstMatch(in: content[checkIndex...]) {
		content.replaceSubrange(match.range, with: "")

		checkIndex = match.range.lowerBound
	}
	checkIndex = content.endIndex
},

{ (content, checkIndex) in
	let rex = /\n(.*?)(struct|class|actor)(.*)\s*?:\s*?HappyCodable/
	guard let match = try? rex.firstMatch(in: content[checkIndex...]) else {
		checkIndex = content.endIndex
		return
	}
	let spaces = match.1.prefix {
		$0.unicodeScalars.first.map {
			CharacterSet.whitespaces.contains($0)
		} ?? false
	}
	let replacement: String = "\n\(spaces)@HappyCodable\(match.0)"

	content.replaceSubrange(match.range, with: replacement)

	let offset = replacement.distance(from: replacement.startIndex, to: replacement.endIndex)

	checkIndex = content.index(match.range.lowerBound, offsetBy: offset)
},

{ (content, checkIndex) in
	let rex = /@HappyCodable\n([\s|\t]*?)@HappyCodable/
	guard let match = try? rex.firstMatch(in: content[checkIndex...]) else {
		checkIndex = content.endIndex
		return
	}
	let replacement: String = "@HappyCodable"

	content.replaceSubrange(match.range, with: replacement)

	let offset = replacement.distance(from: replacement.startIndex, to: replacement.endIndex)

	checkIndex = content.index(match.range.lowerBound, offsetBy: offset)
},
]


let enumerator = FileManager.default.enumerator(at: URL(filePath: path), includingPropertiesForKeys: nil)
let url = URL(fileURLWithPath: "/Volumes/Common/HappyCodable/Tests/HappyCodableTests/ArrayNullTest.swift")
while let url = enumerator?.nextObject() as? URL {
	guard url.pathExtension == "swift" else {
		continue
	}
	var content = try String(contentsOf: url)


	for fix in fixs {
		var checkIndex = content.startIndex
		while checkIndex < content.endIndex {
			fix(&content, &checkIndex)
		}
	}
	try? content.write(to: url, atomically: true, encoding: .utf8)
}


