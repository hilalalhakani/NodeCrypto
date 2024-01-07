// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Main",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16), .macOS(.v13),
    ],
    products: [
        .singleTargetLibrary("AppFeature"),
        .singleTargetLibrary("OnboardingFeature"),
        .singleTargetLibrary("StyleGuide"),
        .singleTargetLibrary("TCAHelpers"),
        .singleTargetLibrary("Keychain"),
        .singleTargetLibrary("ConnectWalletFeature"),
        .singleTargetLibrary("NodeCryptoCore"),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.2"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.1"),
        .package(url: "https://github.com/tgrapperon/swift-dependencies-additions", from: "1.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0"),
        .package(url: "https://github.com/oliverfoggin/swift-composable-analytics", from: "1.1.0"),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", branch: "main")
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "SharedViews",
                "SharedModels",
                "NodeCryptoCore",
                "OnboardingFeature",
                "Keychain",
                "ConnectWalletFeature",
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature",
            ]
        ),
        .target(
            name: "Keychain",
            dependencies: [
                "NodeCryptoCore",
            ]
        ),
        .testTarget(
            name: "KeychainTests",
            dependencies: [
                "Keychain",
            ]
        ),
        .target(
            name: "OnboardingFeature",
            dependencies: [
                "NodeCryptoCore",
            ],
            resources: [
              .process("./Resources"),
            ]
        ),
        .testTarget(
            name: "OnboardingFeatureTests",
            dependencies: [
                "OnboardingFeature",
            ]
        ),
        .target(
            name: "ConnectWalletFeature",
            dependencies: [
                "NodeCryptoCore",
            ]
        ),
        .testTarget(
            name: "ConnectWalletFeatureTests",
            dependencies: [
                "ConnectWalletFeature",
            ]
        ),
        .target(
            name: "SharedViews",
            dependencies: []
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesAdditions", package: "swift-dependencies-additions")
            ]
        ),
        .target(
            name: "NodeCryptoCore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "DependenciesAdditions", package: "swift-dependencies-additions"),
                .product(name: "Tagged", package: "swift-tagged"),
                "StyleGuide",
                "TCAHelpers",
                "SharedModels",
                .product(name: "ComposableAnalytics", package: "swift-composable-analytics"),
            ]
        ),
        .testTarget(
            name: "SnapshotsTests",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                "ConnectWalletFeature",
                "OnboardingFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "TCAHelpers",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "StyleGuide",
            dependencies: [
                // "SharedResources"
            ],
            resources: [
                // .process("./Media.xcassets"),
                .process("./Fonts"),
            ]
        ),
    ]
)

//// Inject base plugins into each target
package.targets = package.targets.map { target in
    var plugins = target.plugins ?? []
    target.plugins = plugins
    return target
}

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
