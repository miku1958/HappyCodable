//
//  Class.swift
//  HappyCodable
//
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

// swiftlint:disable lower_acl_than_parent
// MARK: - empty class
@HappyCodable
class TestClass_empty: HappyCodable {
	required init() { }
}
@HappyCodable
public class TestClass_empty_public: HappyCodable {
	public required init() { }
}
@HappyCodable
private class TestClass_empty_private: HappyCodable {
	required init() { }
}

// MARK: - not empty class
@HappyCodable
class TestClass_notEmpty: HappyCodable {
	required init() { }
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
}

@HappyCodable
public class TestClass_notEmpty_public: HappyCodable {
	public required init() { }
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

@HappyCodable
private class TestClass_notEmpty_private: HappyCodable {
	required init() { }
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
