//
//  ForKeyedDecodingContainer.swift
//  HappyCodable
//
//

import Foundation
import HappyCodable

// swiftlint:disable identifier_name
@HappyCodable(disableWarnings: [.noInitializer])
struct TestStruct_ForKeyedDecodingContainer: HappyCodable {
	@HappyAlterCodingKeys("Bool_1", "Bool_2") var Bool: Bool = false
	@HappyAlterCodingKeys("String_1", "String_2") var String: String = ""
	@HappyAlterCodingKeys("Double_1", "Double_2") var Double: Double = 0
	@HappyAlterCodingKeys("Float_1", "Float_2") var Float: Float = 0
	@HappyAlterCodingKeys("Int_1", "Int_2") var Int: Int = 0
	@HappyAlterCodingKeys("Int8_1", "Int8_2") var Int8: Int8 = 0
	@HappyAlterCodingKeys("Int16_1", "Int16_2") var Int16: Int16 = 0
	@HappyAlterCodingKeys("Int32_1", "Int32_2") var Int32: Int32 = 0
	@HappyAlterCodingKeys("Int64_1", "Int64_2") var Int64: Int64 = 0
	@HappyAlterCodingKeys("UInt_1", "UInt_2") var UInt: UInt = 0
	@HappyAlterCodingKeys("UInt8_1", "UInt8_2") var UInt8: UInt8 = 0
	@HappyAlterCodingKeys("UInt16_1", "UInt16_2") var UInt16: UInt16 = 0
	@HappyAlterCodingKeys("UInt32_1", "UInt32_2") var UInt32: UInt32 = 0
	@HappyAlterCodingKeys("UInt64_1", "UInt64_2") var UInt64: UInt64 = 0
	@HappyAlterCodingKeys("Data_1", "Data_2") var Data: Data? = .init(data: 10)

	@HappyAlterCodingKeys("Bool_optional_1", "Bool_optional_2") var Bool_optional: Bool? = false
	@HappyAlterCodingKeys("String_optional_1", "String_optional_2") var String_optional: String? = ""
	@HappyAlterCodingKeys("Double_optional_1", "Double_optional_2") var Double_optional: Double? = 0
	@HappyAlterCodingKeys("Float_optional_1", "Float_optional_2") var Float_optional: Float? = 0
	@HappyAlterCodingKeys("Int_optional_1", "Int_optional_2") var Int_optional: Int? = 0
	@HappyAlterCodingKeys("Int8_optional_1", "Int8_optional_2") var Int8_optional: Int8? = 0
	@HappyAlterCodingKeys("Int16_optional_1", "Int16_optional_2") var Int16_optional: Int16? = 0
	@HappyAlterCodingKeys("Int32_optional_1", "Int32_optional_2") var Int32_optional: Int32? = 0
	@HappyAlterCodingKeys("Int64_optional_1", "Int64_optional_2") var Int64_optional: Int64? = 0
	@HappyAlterCodingKeys("UInt_optional_1", "UInt_optional_2") var UInt_optional: UInt? = 0
	@HappyAlterCodingKeys("UInt8_optional_1", "UInt8_optional_2") var UInt8_optional: UInt8? = 0
	@HappyAlterCodingKeys("UInt16_optional_1", "UInt16_optional_2") var UInt16_optional: UInt16? = 0
	@HappyAlterCodingKeys("UInt32_optional_1", "UInt32_optional_2") var UInt32_optional: UInt32? = 0
	@HappyAlterCodingKeys("UInt64_optional_1", "UInt64_optional_2") var UInt64_optional: UInt64? = 0
	@HappyAlterCodingKeys("Data_optional_1", "Data_optional_2") var Data_optional: Data?

	struct Data: HappyCodable {
		var data = 0
		init(data: Int = 0) {
			self.data = data
		}
	}
}

@HappyCodable
struct TestStruct_TypeMismatch: HappyCodable {
	var Int: Int = 0
	init(Int: Int = 0) {
		self.Int = Int
	}
}
// swiftlint:enable identifier_name
