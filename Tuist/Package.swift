// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [:]
)
#endif

let package = Package(
    name: "NodeCryptoDependencies",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.1"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.1.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.12.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.6"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.4.0"),
        .package(url: "https://github.com/tgrapperon/swift-dependencies-additions", revision: "0afff683710e63433847641562da5908fe01205f"),
    ]
)
