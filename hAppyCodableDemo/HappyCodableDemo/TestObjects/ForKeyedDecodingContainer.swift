//
//  ForKeyedDecodingContainer.swift
//  HappyCodableDemo
//
//  Created by 庄黛淳华 on 2020/7/31.
//  Copyright © 2020 庄黛淳华. All rights reserved.
//

import Foundation
import HappyCodable

struct TestStruct_ForKeyedDecodingContainer: HappyCodable {
	@Happy.codingKeys("Bool_1", "Bool_2") var Bool: Bool = false
	@Happy.codingKeys("String_1", "String_2") var String: String = ""
	@Happy.codingKeys("Double_1", "Double_2") var Double: Double = 0
	@Happy.codingKeys("Float_1", "Float_2") var Float: Float = 0
	@Happy.codingKeys("Int_1", "Int_2") var Int: Int = 0
	@Happy.codingKeys("Int8_1", "Int8_2") var Int8: Int8 = 0
	@Happy.codingKeys("Int16_1", "Int16_2") var Int16: Int16 = 0
	@Happy.codingKeys("Int32_1", "Int32_2") var Int32: Int32 = 0
	@Happy.codingKeys("Int64_1", "Int64_2") var Int64: Int64 = 0
	@Happy.codingKeys("UInt_1", "UInt_2") var UInt: UInt = 0
	@Happy.codingKeys("UInt8_1", "UInt8_2") var UInt8: UInt8 = 0
	@Happy.codingKeys("UInt16_1", "UInt16_2") var UInt16: UInt16 = 0
	@Happy.codingKeys("UInt32_1", "UInt32_2") var UInt32: UInt32 = 0
	@Happy.codingKeys("UInt64_1", "UInt64_2") var UInt64: UInt64 = 0
	@Happy.codingKeys("Data_1", "Data_2") var Data: Data = .init(data: 100)
	
	
	@Happy.codingKeys("Bool_optional_1", "Bool_optional_2") var Bool_optional: Bool? = false
	@Happy.codingKeys("String_optional_1", "String_optional_2") var String_optional: String? = ""
	@Happy.codingKeys("Double_optional_1", "Double_optional_2") var Double_optional: Double? = 0
	@Happy.codingKeys("Float_optional_1", "Float_optional_2") var Float_optional: Float? = 0
	@Happy.codingKeys("Int_optional_1", "Int_optional_2") var Int_optional: Int? = 0
	@Happy.codingKeys("Int8_optional_1", "Int8_optional_2") var Int8_optional: Int8? = 0
	@Happy.codingKeys("Int16_optional_1", "Int16_optional_2") var Int16_optional: Int16? = 0
	@Happy.codingKeys("Int32_optional_1", "Int32_optional_2") var Int32_optional: Int32? = 0
	@Happy.codingKeys("Int64_optional_1", "Int64_optional_2") var Int64_optional: Int64? = 0
	@Happy.codingKeys("UInt_optional_1", "UInt_optional_2") var UInt_optional: UInt? = 0
	@Happy.codingKeys("UInt8_optional_1", "UInt8_optional_2") var UInt8_optional: UInt8? = 0
	@Happy.codingKeys("UInt16_optional_1", "UInt16_optional_2") var UInt16_optional: UInt16? = 0
	@Happy.codingKeys("UInt32_optional_1", "UInt32_optional_2") var UInt32_optional: UInt32? = 0
	@Happy.codingKeys("UInt64_optional_1", "UInt64_optional_2") var UInt64_optional: UInt64? = 0
	@Happy.codingKeys("Data_optional_1", "Data_optional_2") var Data_optional: Data?
	
	
	struct Data: HappyCodable {
		var data = 0
	}
}
