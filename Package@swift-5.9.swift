// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
	name: "HappyCodable",
	platforms: [
		.iOS("8.0"),
		.macOS("10.15")
	],
	products: [
		.library(
			name: "HappyCodable",
			targets: [
				"HappyCodable",
				"HappyCodableShared"
			]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/apple/swift-syntax.git",
            from: "509.0.0"
		),
	],
	targets: [
		.target(
			name: "HappyCodableShared"
		),
		.macro(
			name: "HappyCodablePlugin",
			dependencies: [
				"HappyCodableShared",
				.product(name: "SwiftSyntax", package: "swift-syntax"),
				.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
				.product(name: "SwiftOperators", package: "swift-syntax"),
				.product(name: "SwiftParser", package: "swift-syntax"),
				.product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
			],
			swiftSettings: [
				.enableUpcomingFeature("BareSlashRegexLiterals")
			]
		),
		.target(
			name: "HappyCodable",
			dependencies: [
				"HappyCodableShared",
				"HappyCodablePlugin",
			]
		),
		.testTarget(
			name: "HappyCodableTests",
			dependencies: [
				"HappyCodable",
				"HappyCodableShared",
			]
		),
		.testTarget(
			name: "HappyCodablePluginTests",
			dependencies: [
				"HappyCodablePlugin",
				"HappyCodableShared",
				.product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
			]
		),
	]
)
