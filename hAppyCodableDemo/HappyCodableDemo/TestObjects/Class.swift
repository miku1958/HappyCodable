//
//  Class.swift
//  CommandLineTests
//
//  Created by 庄黛淳华 on 2020/7/31.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

// 测试规则:
// class/struct/enum
// 空class测试
// 各包含各一个sub class/struct/enum/复杂enum
// 然后包含一个public, internal, private 属性
// internal 包含var/let各一个类型为自己的复杂类型
// internal 包含的var复制一遍改为可选
// private的属性测试时得测试没效果才是正确的
// 一个public的getter
// 一个public方法
// 把整个类复制改成public和private(包括空class)
	// private 的不需要复制基本数据类型的 enum, 因为Swift的编译器会强制要求基本数据类型的 Enum 实现协议方法, 不能用 extension 里的
// 测试的时候, 每个类型都创建一个, 修改属性为随机数据, toJson, fromJson, 对比:
	// 新创建的对象随机数据是否一样
	// private的数据是否默认值

import Foundation
import HappyCodable

// MARK: - empty class
class TestClass_empty: HappyCodable {
	required init() { }
}
public class TestClass_empty_public: HappyCodable {
	public required init() { }
}
private class TestClass_empty_private: HappyCodable {
	required init() { }
}

// MARK: - not empty class
class TestClass_notEmpty: HappyCodable {
	required init() { }
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
	
	enum Enum: String, HappyCodableEnum {
		case abc
	}
	
	enum EnumComplex: RawRepresentable, HappyCodableEnum {
		init?(rawValue: TestClass_empty) {
			self = .efg
		}
		
		var rawValue: TestClass_empty {
			TestClass_empty()
		}
		
		typealias RawValue = TestClass_empty
		
		case abc
		case efg
	}
}
public class TestClass_notEmpty_public: HappyCodable {
	public required init() { }
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
	
	enum Enum: String, HappyCodableEnum {
		case abc
	}
	
	enum EnumComplex: RawRepresentable, HappyCodableEnum {
		init?(rawValue: TestClass_empty) {
			self = .efg
		}
		
		var rawValue: TestClass_empty {
			TestClass_empty()
		}
		
		typealias RawValue = TestClass_empty
		
		case abc
		case efg
	}
}
private class TestClass_notEmpty_private: HappyCodable {
	required init() { }
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
	
	enum EnumComplex: RawRepresentable, HappyCodableEnum {
		init?(rawValue: TestClass_empty) {
			self = .efg
		}
		
		var rawValue: TestClass_empty {
			TestClass_empty()
		}
		
		typealias RawValue = TestClass_empty
		
		case abc
		case efg
	}
}
