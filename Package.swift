// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "home-control-client",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(name: "HomeControlClient", targets: ["HomeControlClient"])
    ],
    dependencies: [
//        .package(path: "../home-control-kit"),
        .package(url: "https://github.com/f23a/home-control-kit.git", from: "1.7.0"),
        .package(url: "https://github.com/f23a/home-control-logging.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "HomeControlClient",
            dependencies: [
                .product(name: "HomeControlKit", package: "home-control-kit"),
                .product(name: "HomeControlLogging", package: "home-control-logging")
            ]
        ),
        .testTarget(
            name: "HomeControlClientTests",
            dependencies: ["HomeControlClient"]
        )
    ]
)
