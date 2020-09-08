# HappyCodable

- [x] 支持WCDB.swift

通过使用 SourceKittenFramework 去自动生成 Codable 代码, 让人更愉悦的使用 Codable

## Codable的问题 ?

1. 不支持自定义某个属性的 coding key, 一旦你有这种需求, 要么把所有的 coding key 手动实现一遍去修改想要的 coding key, 要么就得在 decode 的时候去设置 Decoder , 极其不方便
2. 不支持忽略掉某些不能 Codable 的属性, 还是需要手动实现 coding key 才行
3. 不支持自动合成非 RawRepresentable 的 Enum, 即使该Enum中所有值的子元素都是 Codable 也不行
4. decode 的时候不支持多个 coding key 映射同一个属性
5. 难以调试, 虽然 Codable 是 throw-catch 的, 但是由于代码都是由编译器生成, 数据有问题的时候无法更近一步定位问题
6. 不能使用模型的默认值, 当 decode 的数据缺失时无法使用定义里的默认值而是 throw 数据缺失错误, 这个设计导致例如版本更新后, 服务端删掉了模型的某个过期字段, 然后旧版本 app 都会陷入错误, 即使不用这个字段旧版本客户端依旧是能正常工作的(只是无效的数据显示缺失而已), 这很明显是不合理的.
7. 不支持简单的类型转换, 比如转换 0/1 到 false/true, "123" 到 Int的123 或者反过来, 谁又能确保服务端的人员不会失手修改了字段类型导致 app 端故障呢?

### 而这些, 你全都可以用HappyCodable解决

## 安装

### CocoaPods, 目前只支持这种方式

1. 添加 `pod 'HappyCodable' 到你的 Podfile 文件中:

完成后如下

```
target 'HappyCodableDemo' do
	pod 'HappyCodable'
end
```

2. 执行 pod install

3. 在 Xcode, 你的 project 里打开你的 target, 点击 Build Phases, 在页面左上角点击➕添加 New Run Script Phase, 确保脚本是在 Compile Sources 之前执行: 

```shell
code=$(cat <<EOF
// 需要扫描的路径, ${SRCROOT} 代表整个工程的默认目录, 需要根据需要修改
let scanPath = "${SRCROOT}"

// 生成代码的保存文件目录, 需要根据需要修改
let generatedPath = "${SRCROOT}/HappyCodable.generated.swift"

import HappyCodable
main(path: scanPath, createdFilePath: generatedPath)
dispatchMain()
EOF)

echo "${code}" | DEVELOPER_DIR="$DEVELOPER_DIR" xcrun --sdk macosx "$TOOLCHAIN_DIR/usr/bin/"swift -F "${PODS_ROOT}/HappyCodable.CommandLine" -
```

### 在项目中使用

1. 编译一次你的项目, 首次编译 需要先编译 HappyCodableCommandLine 可能会比较久, 之后除非 clean 或者 achieve 否则都不会增加这部分时间了, 完成后 `HappyCodable.generated.swift` 就会在你的指定目录出现

2. 把 `HappyCodable.generated.swift` 拖进你的项目里(请确保去掉了勾选 Copy items if needed)

   可以把 `*.generated.swift` 添加到你的.gitignore文件中, 请放心, 由于没有编译时类型检查, 外加启用了20条线程进行处理, 创建 `HappyCodable.generated.swift` 所需的时间不会太久

3. 把 `HappyCodable` 应用到你的struct/class/enum, 比如:

```swift
import HappyCodable
struct Person: HappyCodable {
   var name: String = "abc"
   
   @Happy.codingKeys("🆔")
   var id: String = "abc"
   
   @Happy.codingKeys("secret_number", "age") // 第一个 key "secret_number" 将作为coding key
   var age: Int = 18
   
   @Happy.uncoding
   var secret_number: String = "3.1415" // 因为重名了, 类型也不一样, 这时候需要标记为 uncoding, 否则再 decode 的时候会报错
}
```

HappyCodableCommandLine 会自动生成以下代码:

```swift
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
      
      do { self.name = try container.decode(key: "name") } catch { errors.append(error) }
      do { self.id = try container.decode(key: "🆔") } catch { errors.append(error) }
      do { self.age = try container.decode(key: "secret_number", alterKeys: { ["age"] }) } catch { errors.append(error) }
      
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

还有非 RawRepresentable 的 Enum(你需要确保子元素的类型都是 Codable 的):

```swift
import HappyCodable
enum EnumTest: HappyCodableEnum {
   case value(num: Int, name: String)
// case call(() -> Void) 
// 打开这个会编译失败, 因为 (() -> Void) 不是 codable 的
   case name0(String)
   case name1(String, last: String)
   case name2(first: String, String)
   case name3(_ first: String, _ last: String)
}
```

生成的代码: 

```swift
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

1. 因为 HappyCodable 会给需要的类型生成 Codable 方法的 extension 到另外一个文件, 因此没法用于标记为 private 的模型, 同理也没法用于定义在方法里的类型, 例如:

   ```swift
   func getNumber() {
      struct Package: HappyCodable { 
      // ❌外部无法访问所以无法生成extension
         let result: Int
      }
   }
   ```

2. HappyCodable 要求实现一个 `init()` 方法创建一个默认的变量(HappyCodableEnum 不需要), 然后再通过 Codable 给可用的属性编码, 所以它要求编码的属性都是 mutable 的, 像上面的 Package 只读模型, 即使可以访问也没法用了.

## 答疑

1. ### 你为什么会写这个库, 我为什么不用 HandyJSON

   我之前项目是用HandyJSON的, 但由于HandyJSON是基于操作Swift底层数据结构实现的, 已经好几次Swift版本迭代后, 由于数据结构的改变HandyJSON都会出问题, 而我更不建议手动解析模型, 手动的东西永远都信不过, 促使了我写这个库, 配上足够多的测试用例总比手动安全一些

   可能有人会说更新 HandyJSON 不就好了, 但是你既不能确保以后 Swift不 会更新底层数据结构直接导致HandyJSON死亡, 也不能确保你所开发的 APP 突然被迫停止开发后, 你的用户更新系统就不能用了对吧

   为了迁移到 HappyCodable, HappyCodable 的 API 很大程度参考了 HandyJSON, 以后我会写一下迁移指南的(不麻烦, 可能也就十几行而已)

2. ### 我的项目用了其他基于Codable的库(比如WCDB.swift), 能共存吗?

   我测试了 WCDB.swift, 如果手动实现了 CodingKeys, 那 HappyCodable 是不会生成 CodingKeys 的, 直接换上 HappyCodable 也能正常工作
   
   但如果你是新建的模型, 不想手动写 WCDB.swift 的 CodingKeys, 可以在 HappyCodable 生成代码后, 给你的模型的 CodingKeys 添加一个分类去实现 WCDB.swift 的协议就行了, 比原来简单太多, 比如

   ```swift
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

   这是由于 Swift 生成 Codable 的代码是直接在编译时插入到定义里的, 同时如果和其他基于 Codable 的库的协议都写在同一个文件里, Swift 就要求你在定义里实现 Codable 的方法, 所以我需要在 HappyCodable 的 extension 里实现的 init(from decoder: Decoder), 但这又会会导致 Swift 不认 HappyCodable.generated.swift 里的 init 方法, 一直通过 HappyCodable extension 里的 init(from decoder: Decoder) 去创建模型.....
   
   总之在测试了很多方法后最后选择了这么麻烦的办法: 在 HappyCodable extension 里实现 init(from decoder: Decoder), 调用模型的 init() 创建一个空对象, 再调用另一个方法去给属性赋值, 所以需要属性是 mutable 的, 而且其实像 WCDB.swift 这种需要映射数据的, 也要求属性是 mutable 的, 如果有用到的应该也不需要改动多少
