// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BaseIOSApp",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BaseIOSCore",
            targets: ["BaseIOSCore"]),
        .library(
            name: "BaseIOSResources",
            targets: ["BaseIOSResources"]),
        .library(
            name: "BaseIOSUI",
            targets: ["BaseIOSUI"]),
        .library(
            name: "BaseIOSAuth",
            targets: ["BaseIOSAuth"]),
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
            name: "BaseIOSCore",
            dependencies: [
                "Alamofire",
                "Swinject",
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            path: "Sources/BaseIOSCore",
            resources: [
                .process("Mock/Fixtures")
            ]
        ),
        .target(
            name: "BaseIOSResources",
            dependencies: [],
            path: "Sources/BaseIOSResources",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "BaseIOSUI",
            dependencies: [
                "BaseIOSCore",
                "BaseIOSResources",
                "Kingfisher"
            ],
            path: "Sources/BaseIOSUI"
        ),
        .target(
            name: "BaseIOSAuth",
            dependencies: [
                "BaseIOSCore",
                "BaseIOSUI",
                "BaseIOSResources"
            ],
            path: "Sources/BaseIOSAuth"
        ),
        .testTarget(
            name: "BaseIOSAppTests",
            dependencies: ["BaseIOSCore", "BaseIOSUI", "BaseIOSAuth"]
        ),
        .target(
            name: "BaseIOSExample",
            dependencies: ["BaseIOSCore", "BaseIOSUI", "BaseIOSAuth", "BaseIOSResources"],
            path: "Sources/BaseIOSExample"
        ),
        .testTarget(
            name: "BaseIOSExampleTests",
            dependencies: ["BaseIOSExample"],
            path: "Tests/BaseIOSExampleTests"
        )
    ]
)
