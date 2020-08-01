# HappyCodable
通过使用 SourceKittenFramework 去自动生成 Codable 代码, 让人更愉悦的使用 Codable

## Codable的问题 ?

1. 不支持自定义某个属性的 coding key, 一旦你有这种需求, 要么把所有的 coding key 手动实现一遍然后修改想要的 coding key, 要么就得在 decode 的时候去修改 JSONDecoder 的设置, 及其不方便
2. 不支持忽略掉某些不能 Codable 的属性, 有这样的需求还是需要手动实现 coding key 才行
3. 不支持自动合成非 RawRepresentable 的 Enum, 即使该Enum中所有值的子类型都是 Codable 也不行
4. decode 的时候不支持多个 coding key 映射同一个属性
5. 难以调试, 虽然 Codable 是 throw-catch 的, 但是由于代码都是由编译器生成, 数据有问题的时候无法更近一步定位问题
6. 不能使用模型的默认值, 当 decode 的数据缺失时无法使用定义里的默认值, 例如版本更新后, 服务端删掉了模型的某个过期字段, 这时候使用 Codable 只会 throw 数据缺失, 然后旧版本客户端都会陷入错误, 即使不用这个字段旧版本客户端依旧是能正常工作的(只是显示的数据缺失而已), 这很明显是不合理的.
7. 不支持简单的类型映射, 比如转换 0/1 到 false/true, "123" 到 Int的123 或者反过来

### 而这些, 你全都可以用HappyCodable解决

## 安装

### CocoaPods

1. 添加 `pod 'HappyCodable' 到你的 Podfile 文件和执行 pod install

   安装后你可能需要找到 `你的项目/Pods/HappyCodable.CommandLine/HappyCodableCommandLine` ,执行 `chmod +x HappyCodableCommandLine` 把下载的文件变为可执行文件

2. 在 Xcode里: 打开你的项目, 在你的project里打开你的 target, 点击 Build Phases, 在页面左上角点击➕添加 New Run Script Phase

3. 找到新添加的脚本, 把它拉到Compile Sources上面确保编译前执行并且确保是在 Check Pods Manifest.lock下面, 点开脚本把以下内容填入脚本(需要修改target里的路径):

   ```
   tool="$PODS_ROOT/HappyCodable.CommandLine/HappyCodableCommandLine"
   target="${SRCROOT}/{你的swift文件所在的根目录}"
   generated="${SRCROOT}/HappyCodable.generated.swift"
   
   ${tool} ${target} ${generated}
   ```

4. 编译一次你的项目,  `HappyCodable.generated.swift` 应该就会在你的项目根目录出现了, 把 `HappyCodable.generated.swift` 拖进你的项目里(请确保去掉了勾选Copy items if needed)

   建议把 `*.generated.swift` 添加到你的.gitignore文件中

5. 把 `HappyCodable` 应用到你的struct/class/enum, 比如:

```
import HappyCodable
struct Person: HappyCodable {
	var name: String = "abc"
	
	@Happy.codingKeys("🆔")
	var id: String = "abc"
	
	@Happy.codingKeys("secret_number", "age") // the first key will be the coding key
	var age: Int = 18
	
	@Happy.uncoding
	var secret_number: String = "3.1415" // Build fail if coded, in this case, we can "uncoding" it.
}
```

HappyCodableCommandLine 会自动生成以下代码:

```
extension Person {
	enum CodingKeys: String, CodingKey {
		case name
		case id = "🆔"
		case age = "secret_number"
	}
	mutating
	func decode(happyFrom decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: StringCodingKey.self)
		var errors = [Error]()
		
		do { self.name = try container.decode(default: self.name, key: "name") } catch { errors.append(error) }
		do { self.id = try container.decode(default: self.id, key: "🆔") } catch { errors.append(error) }
		do { self.age = try container.decode(default: self.age, key: "secret_number", alterKeys: { ["age"] }) } catch { errors.append(error) }
		
		if !Self.allowHappyDecodableSkipMissing, !errors.isEmpty {
			throw errors
		}
	}
	func encode(happyTo encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		var errors = [Error]()
		do { try container.encodeIfPresent(self.name, forKey: .name) } catch { errors.append(error) }
		do { try container.encodeIfPresent(self.id, forKey: .id) } catch { errors.append(error) }
		do { try container.encodeIfPresent(self.age, forKey: .age) } catch { errors.append(error) }
		if !Self.allowHappyEncodableSafely, !errors.isEmpty {
			throw errors
		}
	}
}
```

还有非 RawRepresentable 的 Enum(你需要确保闭包里的类型都是 Codable 的):

```
import HappyCodable
enum EnumTest: HappyCodableEnum {
	case value(num: Int, name: String)
//	case call(() -> Void) // 打开这个会编译失败, 因为 (() -> Void) 不是 codable 的
	case name0(String)
	case name1(String, last: String)
	case name2(first: String, String)
	case name3(_ first: String, _ last: String)
}
```

生成的代码: 

```
extension EnumTest {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let content = try container.decode([String: [String: String]].self)
		let error = DecodingError.typeMismatch(EnumTest.self, DecodingError.Context(codingPath: [], debugDescription: ""))
		guard let name = content.keys.first else {
			throw error
		}
		let decoder = JSONDecoder()
		switch name {
			case ".value(num:name:)":
				guard
					let _0 = content[name]?["num"]?.data(using: .utf8),
					let _1 = content[name]?["name"]?.data(using: .utf8)
				else {
					throw error
				}
				
				self = .value(
					num: try decoder.decode((Int).self, from: _0),
					name: try decoder.decode((String).self, from: _1)
				)
			case ".name0(_:)":
				guard
					let _0 = content[name]?["$0"]?.data(using: .utf8)
				else {
					throw error
				}
				
				self = .name0(
					try decoder.decode((String).self, from: _0)
				)
			case ".name1(_:last:)":
				guard
					let _0 = content[name]?["$0"]?.data(using: .utf8),
					let _1 = content[name]?["last"]?.data(using: .utf8)
				else {
					throw error
				}
				
				self = .name1(
					try decoder.decode((String).self, from: _0),
					last: try decoder.decode((String).self, from: _1)
				)
			case ".name2(first:_:)":
				guard
					let _0 = content[name]?["first"]?.data(using: .utf8),
					let _1 = content[name]?["$1"]?.data(using: .utf8)
				else {
					throw error
				}
				
				self = .name2(
					first: try decoder.decode((String).self, from: _0),
					try decoder.decode((String).self, from: _1)
				)
			case ".name3(_:_:)":
				guard
					let _0 = content[name]?["first"]?.data(using: .utf8),
					let _1 = content[name]?["last"]?.data(using: .utf8)
				else {
					throw error
				}
				
				self = .name3(
					try decoder.decode((String).self, from: _0),
					try decoder.decode((String).self, from: _1)
				)
		default:
			throw error
		}
	}
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		let encoder = JSONEncoder()
		switch self {
			case let .value(_0, _1):
				try container.encode([
					".value(num:name:)": [
						"num": String(data: try encoder.encode(_0), encoding: .utf8),
						"name": String(data: try encoder.encode(_1), encoding: .utf8)
					]
				])
			case let .name0(_0):
				try container.encode([
					".name0(_:)": [
						"$0": String(data: try encoder.encode(_0), encoding: .utf8)
					]
				])
			case let .name1(_0, _1):
				try container.encode([
					".name1(_:last:)": [
						"$0": String(data: try encoder.encode(_0), encoding: .utf8),
						"last": String(data: try encoder.encode(_1), encoding: .utf8)
					]
				])
			case let .name2(_0, _1):
				try container.encode([
					".name2(first:_:)": [
						"first": String(data: try encoder.encode(_0), encoding: .utf8),
						"$1": String(data: try encoder.encode(_1), encoding: .utf8)
					]
				])
			case let .name3(_0, _1):
				try container.encode([
					".name3(_:_:)": [
						"first": String(data: try encoder.encode(_0), encoding: .utf8),
						"last": String(data: try encoder.encode(_1), encoding: .utf8)
					]
				])
		}
	}
}
```

## 局限性

1. 因为 HappyCodable 是通过生成一个文件给所有需要的类型生成 Codable 方法的 extension, 因此没法用于标记为 private 的模型, 同理也没法用于定义在方法里的模型:

   ```
   func getNumber() {
   	struct Package: Codable {
   		let result: Int
   	}
   }
   ```

2. HappyCodable 要求实现一个 `init()` 方法创建一个默认的变量(HappyCodableEnum 不需要), 然后再通过 Codable 给需要的属性编码, 所以它要求编码的属性都是 mutable 的, 像上面的 Package 这种只读模型就没法用了.

## 答疑

1. ### 你为什么会写这个库, 我为什么不用HandyJSON

   我之前项目是用HandyJSON的, 但是由于HandyJSON是基于操作Swift底层数据结构实现的, 经历了几次Swift版本迭代后HandyJSON都会出问题, 促使了我写这个库

   可能有人会说更新HandyJSON不就好了, 但是你既不能确保以后Swift不会更新底层数据结构不会直接导致HandyJSON死亡, 也不能确保你所开发的APP突然被迫停止开发后你的用户更新系统就不能用了对吧

   为了迁移到HappyCodable, HappyCodable的API很大程度参考了HandyJSON, 以后我会写一下迁移指南的(可能也就100字左右吧)

2. ### 我的项目用了其他基于Codable的库(比如WCDB.swift), 能共存吗?

   我的项目里也用到了WCDB.swift, 如果你手动实现了CodingKeys, 那HappyCodable是不会自动生成CodingKeys的, 如果你不想手动写CodingKeys, 可以在HappyCodable生成代码后, 给你的模型的CodingKeys添加一个分类去实现WCDB.swift的协议就行了, 比原来简单太多, 比如

   ```
   extension LevelInfo.CodingKeys: WCDBSwift.CodingTableKey {
   	typealias Root = LevelInfo
   	static let objectRelationalMapping = TableBinding(Self.self)
   	static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
   		return [
   			"MultiPrimaryConstraint": MultiPrimaryBinding(indexesBy: [subjectId, id])
   		]
   	}
   }
   ```

3. ### 你这库局限性也太大了吧, 既不能用private还要求属性是mutable的

   没办法, Swift自己生成Codable的代码是直接在编译时插入到定义里的, 然后如果和其他基于Codable的库的协议都写在同一个文件里, Swift就要求你在定义里实现Codable的方法, 然后HappyCodable在extension里实现了init(from decoder: Decoder), Swift就不会走模型extension里的init(from decoder: Decoder)了.....总之在测试了很多方法后最后选择了这么麻烦的办法, 在init(from decoder: Decoder)里调用另一个方法去给属性赋值, 所以需要属性是mutable的, 而且像WCDB.swift这种需要映射数据的, 也要求属性是mutable的