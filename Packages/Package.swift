// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Main",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17), .macOS(.v13),
    ],
    products: [
        .singleTargetLibrary("AuthenticationClient"),
        .singleTargetLibrary("AppFeature"),
        .singleTargetLibrary("OnboardingFeature"),
        .singleTargetLibrary("HomeFeature"),
        .singleTargetLibrary("NotificationsFeature"),
        .singleTargetLibrary("StyleGuide"),
        .singleTargetLibrary("TCAHelpers"),
        .singleTargetLibrary("Keychain"),
        .singleTargetLibrary("ConnectWalletFeature"),
        .singleTargetLibrary("NodeCryptoCore"),
        .singleTargetLibrary("Root"),
//        .singleTargetLibrary("APIClient"),
        .singleTargetLibrary("APIClientLive"),
        .singleTargetLibrary("SharedModels"),
        .singleTargetLibrary("ProfileFeature"),
        .singleTargetLibrary("SharedViews"),
        .singleTargetLibrary("SearchFeature"),
        .singleTargetLibrary("CreateFeature"),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.7"),
        .package(url: "https://github.com/oliverfoggin/swift-composable-analytics", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.4.0"),
        .package(url: "https://github.com/tgrapperon/swift-dependencies-additions", branch: "xcode26")
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
                "Root",
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature"
            ]
        ),
        .target(
            name: "AuthenticationClient",
            dependencies: [
                "NodeCryptoCore", "Keychain"
            ]
        ),
        .target(
            name: "Keychain",
            dependencies: [
                "NodeCryptoCore"
            ]
        ),
        .testTarget(
            name: "KeychainTests",
            dependencies: [
                "Keychain"
            ]
        ),
        .target(
            name: "OnboardingFeature",
            dependencies: [
                "NodeCryptoCore"
            ],
            resources: [
                .process("./Resources")
            ]
        ),
        .testTarget(
            name: "OnboardingFeatureTests",
            dependencies: [
                "OnboardingFeature"
            ]
        ),
        .target(
            name: "ConnectWalletFeature",
            dependencies: [
                "NodeCryptoCore",
                "AuthenticationClient",
                "APIClient",
                "Keychain",
            ]
        ),
        .testTarget(
            name: "ConnectWalletFeatureTests",
            dependencies: [
                "ConnectWalletFeature"
            ]
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                "NodeCryptoCore",
                "APIClient",
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: [
                "HomeFeature"
            ]
        ),
        .target(
            name: "SharedViews",
            dependencies: [
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            "StyleGuide"
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "NodeCryptoCore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "DependenciesAdditions", package: "swift-dependencies-additions"),
                "StyleGuide",
                "TCAHelpers",
                "SharedModels",
                .product(name: "ComposableAnalytics", package: "swift-composable-analytics"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ]
        ),
        .testTarget(
            name: "SnapshotsTests",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                "ConnectWalletFeature",
                "OnboardingFeature",
                "ProfileFeature",
                "Root",
                "SearchFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "Root",
            dependencies: ["NodeCryptoCore", "ProfileFeature", "NotificationsFeature", "HomeFeature", "SearchFeature", "CreateFeature"]
        ),
        .target(
            name: "TCAHelpers",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "StyleGuide",
            dependencies: [
                // "SharedResources"
            ],
            resources: [
                // .process("./Media.xcassets"),
                .process("./Fonts")
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                "SharedModels",
            ]
        ),
        .target(
            name: "APIClientLive",
            dependencies: [
                "APIClient",
//                "SharedModels",
//                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "ProfileFeature",
            dependencies: ["NodeCryptoCore", "Keychain", "AuthenticationClient"],
            resources: [
                .process("./Resources")
            ]
        ),
        .testTarget(
            name: "ProfileTests",
            dependencies: [
                "ProfileFeature"
            ]
        ),
        .target(
            name: "NotificationsFeature",
            dependencies: ["NodeCryptoCore", "Keychain", "AuthenticationClient"],
            resources: [
                .process("./Resources")
            ]
        ),
        .target(
            name: "SearchFeature",
            dependencies: ["NodeCryptoCore"],
            resources: [
                .process("./Resources")
            ]
        ),
        .target(
            name: "CreateFeature",
            dependencies: ["NodeCryptoCore"],
            resources: [
              .process("./Resources")
            ]
        ),
        .testTarget(
            name: "CreateFeatureTests",
            dependencies: [
                "CreateFeature"
            ]
        ),
    ]
)

//// Inject base plugins into each target
package.targets = package.targets.map { target in
    let plugins = target.plugins ?? []
    target.plugins = plugins
    return target
}

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
