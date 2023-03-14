// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "Migration",
	platforms: [
		.macOS("13")
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Migration",
			path: "Sources",
			swiftSettings: [
				.unsafeFlags(["-enable-bare-slash-regex"])
			]
		)
    ]
)
