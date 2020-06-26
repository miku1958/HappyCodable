# HappyCodable
A happier codable by using SourceKittenFramework to automatically create code codable relies on by using SourceKittenFramework.

## What's wrong with Codable ?

1. Unsupported changes to single coding key, once you change one coding key, you need to set up all the coding keys.
2. Unsupport ignore specific coding key.
3. Unsupport automatic synthesis for non-RawRepresentable enums, even if each element is codable.
4. Difficulty debugging.
5. Does not automatically use the default values in the definition.

## Usage

1. build the HappyCodable Command Line executable file
2. bring  executable file and HappyCodable Common Source Code to your project
3. add a run script in `build phases` before `compile sources` like:

```
${SRCROOT}/HappyCodableCommandLine ${SRCROOT}/Classes ${SRCROOT}/HappyCodable.generated.swift
```

4. adding `HappyCodable` to a struce/class

```
struct Person: HappyCodable {
	var name1: String = "abc"
	
	@Happy.codingKeys("🍉")
	var numberOfTips2: String = "abc"
	
	@Happy.codingKeys("234", "age", "abc")
	var age: String = "abc"
	
	@Happy.uncoding
	var abc: String = "abc" // Build fail if coded, so we need to "uncode" it.
}
```

and HappyCodableCommandLine will create code automatically:

```
extension Person {
	enum CodingKeys: String, CodingKey {
		case name1
		case numberOfTips2_happy_auto_synthesized_🍉 = "🍉"
		case age_happy_auto_synthesized_234 = "234"
		case age = "age"
		case age_happy_auto_synthesized_abc = "abc"
	}
	mutating
	func decode(happyFrom decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		if Self.globalDecodeAllowOptional {
			do { self.name1 = try container.decode(defaultValue: self.name1, verifyValue: self.name1, forKey: .name1) } catch { }
			do { self.numberOfTips2 = try container.decode(defaultValue: self.numberOfTips2, verifyValue: self.numberOfTips2, forKey: .numberOfTips2_happy_auto_synthesized_🍉) } catch { }
			do { self.age = try container.decode(defaultValue: self.age, verifyValue: self.age, forKey: .age_happy_auto_synthesized_234, .age, .age_happy_auto_synthesized_abc) } catch { }
		} else {
			self.name1 = try container.decode(defaultValue: self.name1, verifyValue: self.name1, forKey: .name1)
			self.numberOfTips2 = try container.decode(defaultValue: self.numberOfTips2, verifyValue: self.numberOfTips2, forKey: .numberOfTips2_happy_auto_synthesized_🍉)
			self.age = try container.decode(defaultValue: self.age, verifyValue: self.age, forKey: .age_happy_auto_synthesized_234, .age, .age_happy_auto_synthesized_abc)
		}
		
	}
	func encode(happyTo encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		if Self.globalEncodeSafely {
			do { try container.encodeIfPresent(self.name1, forKey: .name1) } catch { }
			do { try container.encodeIfPresent(self.numberOfTips2, forKey: .numberOfTips2_happy_auto_synthesized_🍉) } catch { }
			do { try container.encodeIfPresent(self.age, forKey: .age) } catch { }
		} else {
			try container.encode(self.name1, forKey: .name1)
			try container.encode(self.numberOfTips2, forKey: .numberOfTips2_happy_auto_synthesized_🍉)
			try container.encode(self.age, forKey: .age)
		}
	}
}
```

also support non-RawRepresentable enum:

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



