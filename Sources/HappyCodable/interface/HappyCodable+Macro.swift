//
//  HappyCodable+Macro.swift
//  HappyCodable
//
//

import Foundation
@_exported import HappyCodableShared

@attached(member, conformances: HappyCodable, names: named(CodingKeys), named(encode(to:)), named(init(from:)))
public macro HappyCodable(disableWarnings: [Warnings] = []) = #externalMacro(module: "HappyCodablePlugin", type: "HappyCodableMemberMacro")

// MARK: - HappyAlterCodingKeys
@attached(peer)
public macro HappyAlterCodingKeys(_ keys: StaticString...) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - HappyDataStrategy
@attached(peer)
public macro HappyDataStrategy(decode: Foundation.JSONDecoder.DataDecodingStrategy, encode: Foundation.JSONEncoder.DataEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro HappyDataStrategy(encode: Foundation.JSONEncoder.DataEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro HappyDataStrategy(decode: Foundation.JSONDecoder.DataDecodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - HappyNonConformingFloatStrategy
@attached(peer)
public macro HappyNonConformingFloatStrategy(decode: Foundation.JSONDecoder.NonConformingFloatDecodingStrategy, encode: Foundation.JSONEncoder.NonConformingFloatEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro HappyNonConformingFloatStrategy(decode: Foundation.JSONDecoder.NonConformingFloatDecodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro HappyNonConformingFloatStrategy(encode: Foundation.JSONEncoder.NonConformingFloatEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - HappyDateStrategy
@attached(peer)
public macro HappyDateStrategy(decode: Foundation.JSONDecoder.DateDecodingStrategy, encode: Foundation.JSONEncoder.DateEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro HappyDateStrategy(decode: Foundation.JSONDecoder.DateDecodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro HappyDateStrategy(encode: Foundation.JSONEncoder.DateEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - HappyElementNullable
@attached(peer)
public macro HappyElementNullable() = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - HappyUncoding
@attached(peer)
public macro HappyUncoding() = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - HappyDateStrategy
@attached(peer)
public macro DateStrategy(decode: () -> Date) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
