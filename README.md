# HappyCodable

## [中文介绍](https://github.com/miku1958/HappyCodable/blob/master/README.cn.md)

A happier Codable Framework that uses SourceKittenFramework to automatically generate Codable related code.

## What's wrong with Codable ?

1. Unsupported changes to single coding key, once you change one coding key, you need to set up all the coding keys.
2. Unsupported ignore specific coding key.
3. Unsupported automatic synthesis for non-RawRepresentable enums, even if each element is codable.
4. Unsupported multiple key mapping to one property when decoding.
5. Difficulty debugging.
6. Does not automatically use the default values in the definition when missing corresponding key in json data.
7. Unsupported type mapping automatically, like converts 0/1 to false/true.

### And all this, can be solved by using **HappyCodable**

## Installation

### CocoaPods

1. Add `pod 'HappyCodable'` to your Podfile and run pod install

   After install, you may need to find the `YourProject/Pods/HappyCodable.CommandLine/HappyCodableCommandLine` and run `chmod +x HappyCodableCommandLine` to make it executable

2. In Xcode: Click on your project in the file list, choose your target under TARGETS, click the Build Phases tab and add a New Run Script Phase by clicking the little plus icon in the top left

3. Drag the new Run Script phase above the Compile Sources phase and below Check Pods Manifest.lock, expand it and paste the following script:

   ```
   tool="$PODS_ROOT/HappyCodable.CommandLine/HappyCodableCommandLine"
   target="${SRCROOT}/{THE FOLDER YOU WANT TO ANALYSIS}"
   generated="${SRCROOT}/HappyCodable.generated.swift"
   
   ${tool} ${target} ${generated}
   ```

4. Build your project, in Finder you will now see a `HappyCodable.generated.swift` in the $SRCROOT-folder, drag the  `HappyCodable.generated.swift`  files into your project and uncheck Copy items if needed

   Tip: Add the *.generated.swift pattern to your .gitignore file to prevent unnecessary conflicts.

5. Adding `HappyCodable` to a struct/class/enum like:

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

and HappyCodableCommandLine will create code automatically:

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

also support non-RawRepresentable Enum(you need to premise the parameter Type is Codable):

```
import HappyCodable
enum EnumTest: HappyCodableEnum {
	case value(num: Int, name: String)
//	case call(() -> Void) // Build fails if added, since (() -> Void) can't be codable
	case name0(String)
	case name1(String, last: String)
	case name2(first: String, String)
	case name3(_ first: String, _ last: String)
}
```

generated code: 

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

## Limitation

1. Because HappyCodable uses an extension file to generate Codable's functions, thus it can't be used for private Model Types, and it can't be used for models that are defined in function either:

   ```
   func getNumber() {
   	struct Package: Codable {
   		let result: Int
   	}
   }
   ```

2. HappyCodable requires a `init()` to create a default object for the model(HappyCodableEnum not required), and then to change the property using Codable, so it requires that the coding properties are mutable. So it can't use for read only Model, for example, the above Package struct.

## Q&A

1. ### Why are you creating HappyCodable, and why don't I use HandyJSON

   My project was using HandyJSON, but it's based on Swift's low-level data structure, and after Swift changed its structure several times that led to HandyJSON having issues, so I wrote HappyCodable

   Maybe someone will say: just updating HandyJSON is fine, but you can't ensure that HandyJSON won't die after some Swift data structure change, or you APP won't suddenly stop developing, and then your users won't be able to use it anymore after updating iOS right?

   For migrating to HappyCodable, the APIs are largely reference to HandyJSON,  I can actually write a guide about this(perhaps just about 100 words)

2. ### My project is using another framework based on Codable(like WCDB.swift), is that working?

   I tested WCDB.swift, if you achieve CodingKeys manually, HappyCodable will not generate CodingKeys. You can also extend your model's CodingKeys to implement WCDB.swift's protocols after HappyCodable finishes working; it's too much simpler: 

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

3. ### There are a lot of limitations to your framework. You can either use private but also require propertys to be mutable

   Because the code that Swift generates by itself is inserted into the definition directly at compile time, and then if the protocols of other Codable-based libraries are written in the same file, Swift requires you to implement the method of Codable in the definition. Then HappyCodable implements init(from decoder: Decoder) in the extension, Swift will not use the init(from decoder: Decoder) in the model extension...In short, after testing many methods, I finally chose such a troublesome The solution is to call another method in init (from decoder: Decoder) to assign a value to the properties, so the properties have to be mutable, and for data mapping like WCDB.swift, the properties are required to be mutable too

