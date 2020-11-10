# HappyCodable

通过自定义的 Decoder 配合 Property wrapper 实现优雅 JSON Codable

## 2020.11.10 备注

目前 Swift 编译器存在缺陷, 当 Property wraper 使用 @escaping @autoclosure 闭包作为初始化参数时会编译出错, 9月份的 Swift Development Snapshot 已经修复这个问题, 但 Xcode 12.2 尚未包含该 patcher https://bugs.swift.org/browse/SR-13606 等到 Xcode 更新修复后我会发布本次 2.0 版本到 CocoaPods 和 Swift Package Manager

## 与 1.x 的区别

移除了`基于 SourceKitten 生成代码的实现方式`, 改为`编译时`加`自定义的 Decoder` 的方式实现, 不再需要额外配置编译脚本和引入生成文件

​	和原生 Codable 一样支持任意访问权限的类型

​	由于使用了编译器生成的`init(from:)`, 所以无法支持`willStartMapping()`, 只保留`didFinishMapping()`调用

​	无法支持自动合成非 RawRepresentable 的 Enum

​	无法自动合成默认 CodingKeys, 如果是用 WCDB.swift 需要手写一遍了, 同时`@Happy.uncoding`不再支持第三方(包括Foundation.JSONDecoder), 如果需要 “使用第三方 Codable 且使用 uncoding 的功能”, 则需要自己实现 CodingKeys 而不是使用`@Happy.uncoding`

​	由于依赖于系统生成的 CodingKeys, 为了防止岐意, `@Happy.codingKeys`改名为`@Happy.alterCodingKeys`代表替代coding keys, 并且始终优先解析 CodingKeys 中定义的字段避免基于 Codable 的第三方库出错(例如 WCDB.swift)

​	未来会进一步分离开放自定义的 Decoder 以方便接入其他数据类型的 Decoder (例如 XML, Protocol Buffers 等等)

新增了新的 Property wrapper 替代原本 JSON Codable 的参数配置, 例如 @Happy.dateStrategy

由于 decode 的时候需要 encode 一次作为默认值是用, 所以移除了 HappyEncodable, HappyCodable 需要同时实现 Decodable 和 Encodable, 为了防止使用运行时变量时 encode 的值不符合实际情况(`例如 var date = Date()`), 所有@Happy.propertyWrapper 都会使用 @autoclosure 的方式记录默认值, 如果有临时需要可以使用`@Happy.dynamicDefault`标示

## 原生 JSON Codable 的问题 ?

1. 不支持自定义某个属性的 coding key, 一旦你有这种需求, 要么把所有的 coding key 手动实现一遍去修改想要的 coding key, 要么就得在 decode 的时候去设置 Decoder , 极其不方便
2. 不支持忽略掉某些不能 Codable 的属性, 还是需要手动实现 coding key 才行
4. decode 的时候不支持多个 coding key 映射同一个属性
6. 不能使用模型的默认值, 当 decode 的数据缺失时无法使用定义里的默认值而是 throw 数据缺失错误, 这个设计导致例如版本更新后, 服务端删掉了模型的某个过期字段, 然后旧版本 app 都会陷入错误, 即使不用这个字段旧版本客户端依旧是能正常工作的(只是无效的数据显示缺失而已), 这很明显是不合理的.
7. 不支持简单的类型转换, 比如转换 0/1 到 false/true, "123" 到 Int的123 或者反过来, 谁又能确保服务端的人员不会失手修改了字段类型导致 app 端故障呢?

而这些, 你全都可以用HappyCodable解决

## 安装

### CocoaPods

1. 添加 `pod 'HappyCodable' 到你的 Podfile 文件中:

完成后如下

```
target 'HappyCodableDemo' do
pod 'HappyCodable'
end
```

2. 执行 pod install


### 在项目中使用

把 `HappyCodable` 应用到你的struct/class/enum, 比如:

```swift
import HappyCodable
struct Person: HappyCodable {
   var name: String = "abc"
   
   @Happy.alterCodingKeys("🆔")
   var id: String = "abc"
   
   @Happy.alterCodingKeys("secret_number", "age")
   var age: Int = 18
   
   @Happy.uncoding
   var secret_number: String = "3.1415"
}
```

## 答疑

1. ### 你为什么会写这个库, 我为什么不用 HandyJSON

   我之前项目是用 HandyJSON 的, 但由于 HandyJSON 是基于操作 Swift 底层数据结构实现的, 已经好几次 Swift 版本迭代后, 由于数据结构的改变 HandyJSON 都会出问题, 由于我不想手动解析模型, 促使了我写这个库, 配上足够多的测试用例总比手动安全一些

   可能有人会说更新 HandyJSON 不就好了, 但是你既不能确保以后 Swift 不会更新底层数据结构后, 直接导致HandyJSON 死亡, 也不能确保你所开发的 APP 突然被迫停止开发后, 你的用户更新系统就不能用了对吧

   为了迁移到 HappyCodable, HappyCodable 的 API 很大程度参考了 HandyJSON

2. ### 我的项目用了其他基于Codable的库(比如WCDB.swift), 能共存吗?

   可以, 但还是得手动实现 CodingKeys

3. 待补充...
