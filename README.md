# HappyCodable
A happier Codable by using SourceKittenFramework to automatically create Codable related code.

## What's wrong with Codable ?

1. Unsupported changes to single coding key, once you change one coding key, you need to set up all the coding keys.
2. Unsupported ignore specific coding key.
3. Unsupported automatic synthesis for non-RawRepresentable enums, even if each element is codable.
4. Unsupported multiple key mapping to one property
5. Difficulty debugging.
6. Does not automatically use the default values in the definition when missing corresponding key in json data.
7. Unsupported 0/1 to false/true

### And all this, can be solved by using **HappyCodable**

## Usage

1. build the HappyCodable Command Line executable file
2. bring  executable file and HappyCodable Common Source Code to your project
3. add a run script in `build phases` before `compile sources` like:

```
${SRCROOT}/HappyCodableCommandLine ${SRCROOT}/Classes ${SRCROOT}/HappyCodable.generated.swift
```

4. adding `HappyCodable` to a struct/class

```
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
		
		do { self.name = try container.decode(default: self.name, key: "name", alterKeys: []) } catch { errors.append(error) }
		do { self.id = try container.decode(default: self.id, key: "🆔", alterKeys: []) } catch { errors.append(error) }
		do { self.age = try container.decode(default: self.age, key: "secret_number", alterKeys: ["age"]) } catch { errors.append(error) }
		
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

also support non-RawRepresentable enum(you need to premise the parameter Type is Codable):

```
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

2. HappyCodable requires a `init()` to create a base for the model, and then to change the property using Codable, so it requires that the coding properties are mutable. So it can't use for read only Model, for example, the above Package struct.

