// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xclogparser2sonar",
    platforms: [
            .macOS(.v10_11),
        ],
    products: [
        .executable(name: "xclogparser2sonar", targets: ["XCLogParser2Sonar"]),
        .library(name: "xclogparser2sonarlib", targets: ["XCLogParser2SonarCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.3"),
    ],
    targets: [
        .target(
            name: "XCLogParser2Sonar",
            dependencies: [
                "XCLogParser2SonarCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "XCLogParser2SonarCore",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "XCLogParser2SonarTests",
            dependencies: [
                "XCLogParser2Sonar"
            ],
            resources: [
                .copy("example.json")
            ]
        ),
    ]
)
