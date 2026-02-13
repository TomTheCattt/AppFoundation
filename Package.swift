// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppFoundation",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppFoundation",
            targets: ["AppFoundation"]),
        .library(
            name: "AppFoundationResources",
            targets: ["AppFoundationResources"]),
        .library(
            name: "AppFoundationUI",
            targets: ["AppFoundationUI"]),
        .library(
            name: "AppFoundationAuth",
            targets: ["AppFoundationAuth"]),
        
        // Build Tool Plugins
        .plugin(
            name: "SwiftLintPlugin",
            targets: ["SwiftLintPlugin"]),
        .plugin(
            name: "SwiftGenPlugin",
            targets: ["SwiftGenPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.0"),
        .package(url: "https://github.com/Swinject/Swinject", from: "2.8.0"),
        .package(url: "https://github.com/realm/realm-swift", from: "10.40.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppFoundation",
            dependencies: [
                "Alamofire",
                "Swinject",
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            path: "Sources/AppFoundation",
            resources: [
                .process("Mock/Fixtures")
            ]
        ),
        .target(
            name: "AppFoundationResources",
            dependencies: [],
            path: "Sources/AppFoundationResources",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AppFoundationUI",
            dependencies: [
                "AppFoundation",
                "AppFoundationResources",
                "Kingfisher"
            ],
            path: "Sources/AppFoundationUI"
        ),
        .target(
            name: "AppFoundationAuth",
            dependencies: [
                "AppFoundation",
                "AppFoundationUI",
                "AppFoundationResources"
            ],
            path: "Sources/AppFoundationAuth"
        ),
        .testTarget(
            name: "AppFoundationTests",
            dependencies: ["AppFoundation", "AppFoundationUI", "AppFoundationAuth"]
        ),
        .target(
            name: "AppFoundationExample",
            dependencies: ["AppFoundation", "AppFoundationUI", "AppFoundationAuth", "AppFoundationResources"],
            path: "Sources/AppFoundationExample"
        ),
        .testTarget(
            name: "AppFoundationExampleTests",
            dependencies: ["AppFoundationExample"],
            path: "Tests/AppFoundationExampleTests"
        ),
        
        // Build Tool Plugins
        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            path: "Plugins/SwiftLintPlugin"
        ),
        .plugin(
            name: "SwiftGenPlugin",
            capability: .buildTool(),
            path: "Plugins/SwiftGenPlugin"
        )
    ]
)
