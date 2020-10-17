//
//  struct.swift
//  CommandLineTests
//
//  Created by 庄黛淳华 on 2020/7/31.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

// MARK: - empty struct
struct TestStruct_empty: HappyCodable {
	
}
public struct TestStruct_empty_public: HappyCodable {
	public init() { }
}
private struct TestStruct_empty_private: HappyCodable {
	
}

// MARK: - not empty struct
struct TestStruct_notEmpty: HappyCodable {
	public var int: Int = 0
	internal var object: Class = Class()
	internal var objectNil: Struct?
	private var string: String = ""
	
	public var getter: Void { () }
	public func function() { }
	
	class Class: HappyCodable {
		required init() { }
		var int: Int = 0
		var string: String = ""
	}
	
	struct Struct: HappyCodable {
		var int: Int = 0
		var string: String = ""
	}
}
public struct TestStruct_notEmpty_public: HappyCodable {
	public init() { }
	public var int: Int = 0
	internal var object: Class = Class()
	internal var objectNil: Struct?
	private var string: String = ""
	
	public var getter: Void { () }
	public func function() { }
	
	class Class: HappyCodable {
		required init() { }
		var int: Int = 0
		var string: String = ""
	}
	
	struct Struct: HappyCodable {
		var int: Int = 0
		var string: String = ""
	}
}
private struct TestStruct_notEmpty_private: HappyCodable {
	public var int: Int = 0
	internal var object: Class = Class()
	internal var objectNil: Struct?
	private var string: String = ""
	
	public var getter: Void { () }
	public func function() { }
	
	class Class: HappyCodable {
		required init() { }
		var int: Int = 0
		var string: String = ""
	}
	
	struct Struct: HappyCodable {
		var int: Int = 0
		var string: String = ""
	}
}
