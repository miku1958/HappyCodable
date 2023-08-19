//
//  DecodeError.swift
//  HappyCodable
//
//

import Foundation

public enum DecodeError: String, Swift.Error {
	case inputEmpty
	case invalidDesignatedPath
	case typeError
	case datableFail
	case unsupportedDecoder
}
