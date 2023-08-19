//
//  HappyCodable+Macro.swift
//  HappyCodable
//
//

import Foundation
@_exported import HappyCodableShared

@attached(member, conformances: HappyCodable, names: named(CodingKeys), named(encode(to:)), named(init(from:)))
public macro HappyCodable(disableWarnings: [Warnings] = []) = #externalMacro(module: "HappyCodablePlugin", type: "HappyCodableMemberMacro")

// MARK: - AlterCodingKeys
@attached(peer)
public macro AlterCodingKeys(_ keys: StaticString...) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - DataStrategy
@attached(peer)
public macro DataStrategy(decode: Foundation.JSONDecoder.DataDecodingStrategy, encode: Foundation.JSONEncoder.DataEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro DataStrategy(encode: Foundation.JSONEncoder.DataEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro DataStrategy(decode: Foundation.JSONDecoder.DataDecodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - FloatStrategy
@attached(peer)
public macro FloatStrategy(decode: Foundation.JSONDecoder.NonConformingFloatDecodingStrategy, encode: Foundation.JSONEncoder.NonConformingFloatEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro FloatStrategy(decode: Foundation.JSONDecoder.NonConformingFloatDecodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro FloatStrategy(encode: Foundation.JSONEncoder.NonConformingFloatEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - DateStrategy
@attached(peer)
public macro DateStrategy(decode: Foundation.JSONDecoder.DateDecodingStrategy, encode: Foundation.JSONEncoder.DateEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro DateStrategy(decode: Foundation.JSONDecoder.DateDecodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
@attached(peer)
public macro DateStrategy(encode: Foundation.JSONEncoder.DateEncodingStrategy) = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - ElementNullable
@attached(peer)
public macro ElementNullable() = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")

// MARK: - Uncoding
@attached(peer)
public macro Uncoding() = #externalMacro(module: "HappyCodablePlugin", type: "AttributePlaceholderMacro")
