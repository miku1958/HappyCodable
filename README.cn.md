# HappyCodable

使用Swift Macro 实现优雅的 Codable



## 与 3.x 的区别

从`编译时`加`自定义的 Decoder` 的方式实现改为使用Swift Macro 实现(目前只支持Swift Package)

相比自定义的 Decoder有以下好处:

1. 不用再维护自定义的 Decoder
2. 更进一步地减少PropertyWrapper的运行时的开销
3. 更简单地实现
4. 因为不再依赖extension, 因此extension的限制将被解除, 比如混用其他第三方的Coder时, 不用手写CodingKeys了
5. 因为Swift Macro不支持命名空间, 所以@Happy.的前缀需要被移除

## 原生 JSON Codable 的问题 ?

1. 不支持自定义某个属性的 coding key, 一旦你有这种需求, 要么把所有的 coding key 手动实现一遍去修改想要的 coding key, 要么就得在 decode 的时候去设置 Decoder , 极其不方便
2. 不支持忽略掉某些不能 Codable 的属性, 还是需要手动实现 coding key 才行
3. decode 的时候不支持多个 coding key 映射同一个属性
4. 不能使用模型的默认值, 当 decode 的数据缺失时无法使用定义里的默认值而是 throw 数据缺失错误, 这个设计导致例如版本更新后, 服务端删掉了模型的某个过期字段, 然后旧版本 app 都会陷入错误, 即使不用这个字段旧版本客户端依旧是能正常工作的(只是无效的数据显示缺失而已), 这很明显是不合理的.
5. 不支持简单的类型转换, 比如转换 0/1 到 false/true, "123" 到 Int的123 或者反过来, 谁又能确保服务端的人员不会失手修改了字段类型导致 app 端故障呢?

而这些, 你全都可以用HappyCodable解决

## 安装

### Swift Package

1. 添加该repo到项目的Swift package中, 设置版本为 4.0.2 或以上

<img width="833" alt="image" src="https://github.com/miku1958/HappyCodable/assets/24806909/b0ed5417-734e-4982-9fe4-45b7ebebb9c5">

2. 添加 HappyCodable 到需要的target里

<img width="767" alt="image" src="https://github.com/miku1958/HappyCodable/assets/24806909/d75b60c3-def7-45e0-97b2-e166272f38a7">

3. 编译一次后查看 warnings / errors, 选择 trust HappyCodable

<img width="277" alt="Screenshot 2023-09-22 at 19 31 45" src="https://github.com/miku1958/HappyCodable/assets/24806909/8ecf54b0-0812-465f-b0f4-cbf45943bc8c">


### 在项目中使用

把 `HappyCodable` 应用到你的struct/class/enum:

```swift
import HappyCodable

extension HappyEncodable {
  static var decodeHelper:  DecodeHelper {
    .init()
  }
}

extension HappyDecodable {
  static var encodeHelper: EncodeHelper {
    .init()
  }
}

@HappyCodable
struct Person: HappyCodable {
  var name: String = "abc"

  @AlterCodingKeys("🆔")
  var id: String = "abc"

  @AlterCodingKeys("secret_number", "age")
  var age: Int = 18

  @DataStrategy(decode: .deferredToData, encode: .deferredToData)
  var data_deferredToData: Data = Data()

  @DateStrategy(decode: .secondsSince1970, encode: .secondsSince1970)
  var date_secondsSince1970: Date = Date(timeIntervalSince1970: 1234)

  @AlterCodingKeys("data1")
  @ElementNullable
  var data: [String] = []

  @Uncoding
  var secret_number: String = "3.1415"

  init() { }
}

## 答疑

1. ### 你为什么会写这个库, 我为什么不用 HandyJSON

   我之前项目是用 HandyJSON 的, 但由于 HandyJSON 是基于操作 Swift 底层数据结构实现的, 已经好几次 Swift 版本迭代后, 由于数据结构的改变 HandyJSON 都会出问题, 由于我不想手动解析模型, 促使了我写这个库, 配上足够多的测试用例总比手动安全一些

   可能有人会说更新 HandyJSON 不就好了, 但是你既不能确保以后 Swift 不会更新底层数据结构后, 直接导致HandyJSON 死亡, 也不能确保你所开发的 APP 突然被迫停止开发后, 你的用户更新系统就不能用了对吧

   为了迁移到 HappyCodable, HappyCodable 的 API 很大程度参考了 HandyJSON

2. ### 我的项目用了其他基于Codable的库(比如WCDB.swift), 能共存吗?

   可以

3. 待补充...
