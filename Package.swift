// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let commonPlugins: [Target.PluginUsage] = [
	.plugin(name: "SwiftLint")
]

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
			branch: "main"
		),
	],
	targets: [
		.target(
			name: "HappyCodableShared",
			plugins: commonPlugins
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
			],
			plugins: commonPlugins
		),
		.target(
			name: "HappyCodable",
			dependencies: [
				"HappyCodableShared",
				"HappyCodablePlugin",
			],
			plugins: commonPlugins
		),
		.testTarget(
			name: "HappyCodableTests",
			dependencies: [
				"HappyCodable",
				"HappyCodableShared",
			],
			plugins: commonPlugins
		),
		.testTarget(
			name: "HappyCodablePluginTests",
			dependencies: [
				"HappyCodablePlugin",
				"HappyCodableShared",
				.product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
			],
			plugins: commonPlugins
		),

		// MARK: - Build Tools
		.binaryTarget(
			name: "SwiftLintBinary",
			url: "https://github.com/realm/SwiftLint/releases/download/0.52.2/SwiftLintBinary-macos.artifactbundle.zip",
			checksum: "89651e1c87fb62faf076ef785a5b1af7f43570b2b74c6773526e0d5114e0578e"
		),
		.plugin(
			name: "SwiftLint",
			capability: .buildTool(),
			dependencies: ["SwiftLintBinary"],
			path: "Plugins/Lint"
		),
	]
)
