# HappyCodable

Elegant Codable implementation using Swift Macro

## Differences from version 3.x

The way of implementing a custom decoder at compile time has been changed to using Swift Macro (currently only supported by Swift Package). This has the following benefits over a custom decoder:

1. No need to maintain a custom decoder
2. Further reduces the runtime overhead of PropertyWrapper
3. Simpler implementation
4. Since it no longer relies on extensions, extension restrictions will be lifted. For example, when using other third-party Coders, you no longer need to manually write CodingKeys
5. Because Swift Macro does not support namespaces, the @Happy prefix needs to be removed

## Issues with native JSON Codable?

1. Does not support custom coding keys for a property. Once you have this requirement, you either have to manually implement all the coding keys and modify the ones you want, or set the Decoder during decoding, which is extremely inconvenient.
2. Does not support ignoring properties that cannot be Codable. You still need to manually implement coding keys.
3. Does not support multiple coding keys mapping to the same property during decoding.
4. Cannot use the model's default values. When decoding data is missing, you cannot use the default values defined in the model and instead throw a data missing error. This design leads to errors when, for example, a server deletes an outdated field of a model after a version update, and old version apps will all be in error, even if they don't use this field (only invalid data is missing). This is clearly unreasonable.
5. Does not support simple type conversion, such as converting 0/1 to false/true, "123" to Int's 123 or vice versa. Who can guarantee that the server personnel will not accidentally modify the field type and cause a failure on the app side?

All of these can be solved with HappyCodable.

## Installation

### Swift Package

1. Add this repo to your project's Swift package, set the version to 4.0.2 or higher
<img width="833" alt="image" src="https://github.com/miku1958/HappyCodable/assets/24806909/b0ed5417-734e-4982-9fe4-45b7ebebb9c5">
2. Add HappyCodable to the desired project
<img width="767" alt="image" src="https://github.com/miku1958/HappyCodable/assets/24806909/d75b60c3-def7-45e0-97b2-e166272f38a7">
3. View warnings and errors after compiling, trust HappyCodable
<img width="277" alt="Screenshot 2023-09-22 at 19 31 45" src="https://github.com/miku1958/HappyCodable/assets/24806909/8ecf54b0-0812-465f-b0f4-cbf45943bc8c">

### Using in your project

Apply `HappyCodable` to your struct/class/enum:

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
```

## Q&A

1. ### Why did you write this library, and why not use HandyJSON?

   I used HandyJSON before, but because HandyJSON is based on operating on Swift's underlying data structures, it has had problems several times after Swift version updates due to changes in data structures. Since I don't want to manually parse models, it prompted me to write this library. Having enough test cases with HappyCodable is safer than manual implementation.

   Some people might say that updating HandyJSON is enough, but you can't guarantee that Swift won't update the underlying data structure in the future, causing HandyJSON to die. Nor can you guarantee that your app suddenly stops development and your users can't use it after updating the system.

   To migrate to HappyCodable, HappyCodable's API is largely based on HandyJSON.

2. ### Can it coexist with other Codable-based libraries in my project (such as WCDB.swift)?

   Yes.

3. To be continued...
