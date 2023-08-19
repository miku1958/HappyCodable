//
//  Struct.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

// swiftlint:disable lower_acl_than_parent

// MARK: - empty struct
@HappyCodable(disableWarnings: [.noInitializer])
struct TestStruct_empty: HappyCodable {

}
@HappyCodable
public struct TestStruct_empty_public: HappyCodable {
	public init() { }
}
@HappyCodable(disableWarnings: [.noInitializer])
private struct TestStruct_empty_private: HappyCodable {

}

// MARK: - not empty struct
@HappyCodable
struct TestStruct_notEmpty: HappyCodable {
	public var int: Int = 0
	var object: Class = Class()
	var objectNil: Struct?
	private var string: String = ""

	public var getter: Void { () }
	public func function() { }

	@HappyCodable
	class Class: HappyCodable {
		required init() { }
		var int: Int = 0
		var string: String = ""
	}

	@HappyCodable
	struct Struct: HappyCodable {
		var int: Int = 0
		var string: String = ""

		init() { }
	}

	init() { }
}
@HappyCodable
public struct TestStruct_notEmpty_public: HappyCodable {
	public init() { }
	public var int: Int = 0
	var object: Class = Class()
	var objectNil: Struct?
	private var string: String = ""

	public var getter: Void { () }
	public func function() { }

	@HappyCodable
	class Class: HappyCodable {
		required init() { }
		var int: Int = 0
		var string: String = ""
	}

	@HappyCodable(disableWarnings: [.noInitializer])
	struct Struct: HappyCodable {
		var int: Int = 0
		var string: String = ""
	}
}
@HappyCodable(disableWarnings: [.noInitializer])
private struct TestStruct_notEmpty_private: HappyCodable {
	public var int: Int = 0
	var object: Class = Class()
	var objectNil: Struct?
	private var string: String = ""

	public var getter: Void { () }
	public func function() { }

	@HappyCodable
	class Class: HappyCodable {
		required init() { }
		var int: Int = 0
		var string: String = ""
	}

	@HappyCodable(disableWarnings: [.noInitializer])
	struct Struct: HappyCodable {
		var int: Int = 0
		var string: String = ""
	}
}

// swiftlint:enable lower_acl_than_parent
