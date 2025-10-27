// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Main",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v13),
    ],
    products: [
        // Core Infrastructure
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "Root", targets: ["Root"]),

        // Features
        .library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
        .library(name: "HomeFeature", targets: ["HomeFeature"]),
        .library(name: "ProfileFeature", targets: ["ProfileFeature"]),
        .library(name: "SearchFeature", targets: ["SearchFeature"]),
        .library(name: "CreateFeature", targets: ["CreateFeature"]),
        .library(name: "NotificationsFeature", targets: ["NotificationsFeature"]),
        .library(name: "ConnectWalletFeature", targets: ["ConnectWalletFeature"]),

        // Shared Utilities
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SharedViews", targets: ["SharedViews"]),
        .library(name: "StyleGuide", targets: ["StyleGuide"]),
        .library(name: "TCAHelpers", targets: ["TCAHelpers"]),

        // Clients & Services
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "APIClientLive", targets: ["APIClientLive"]),
        .library(name: "AuthenticationClient", targets: ["AuthenticationClient"]),
        .library(name: "Keychain", targets: ["Keychain"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.7"),
        .package(url: "https://github.com/oliverfoggin/swift-composable-analytics", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.4.0"),
        .package(url: "https://github.com/tgrapperon/swift-dependencies-additions", branch: "xcode26"),
    ],
    targets: [
        // MARK: - Core Infrastructure

        .target(
            name: "AppFeature",
            dependencies: [
                "Root",
                "OnboardingFeature",
                "ConnectWalletFeature",
                "SharedViews",
                "SharedModels",
                "Keychain",
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]
        ),

        .target(
            name: "Root",
            dependencies: [
                "HomeFeature",
                "ProfileFeature",
                "NotificationsFeature",
                "SearchFeature",
                "CreateFeature",
            ]
        ),

        // MARK: - Features

        .target(
            name: "OnboardingFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "TCAHelpers",
                "StyleGuide",
                .product(name: "ComposableAnalytics", package: "swift-composable-analytics"),
                "SharedViews"
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "OnboardingFeatureTests",
            dependencies: ["OnboardingFeature"]
        ),

        .target(
            name: "HomeFeature",
            dependencies: [
                "APIClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "TCAHelpers",
                .product(name: "Dependencies", package: "swift-dependencies"),
                "SharedModels",
                "SharedViews",
                "StyleGuide"
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: ["HomeFeature"]
        ),

        .target(
            name: "ProfileFeature",
            dependencies: [
                "Keychain",
                "AuthenticationClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "StyleGuide",
                "APIClient",
                "TCAHelpers",
                "SharedViews"
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "ProfileTests",
            dependencies: ["ProfileFeature"]
        ),

        .target(
            name: "SearchFeature",
            dependencies: [
                "APIClient",
                "SharedViews",
                "StyleGuide",
                "TCAHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Resources")]
        ),

        .target(
            name: "CreateFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "SharedViews",
                "TCAHelpers"
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "CreateFeatureTests",
            dependencies: ["CreateFeature"]
        ),

        .target(
            name: "NotificationsFeature",
            dependencies: [
                "Keychain",
                "AuthenticationClient",
                "APIClient",
                "TCAHelpers",
                "StyleGuide",
                "SharedViews",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            resources: [.process("Resources")]
        ),

        .target(
            name: "ConnectWalletFeature",
            dependencies: [
                "APIClient",
                "AuthenticationClient",
                "Keychain",
                .product(name: "ComposableAnalytics", package: "swift-composable-analytics"),
                "StyleGuide",
                "TCAHelpers",
                .product(name: "DependenciesAdditions", package: "swift-dependencies-additions")
            ]
        ),
        .testTarget(
            name: "ConnectWalletFeatureTests",
            dependencies: ["ConnectWalletFeature"]
        ),

        // MARK: - Shared Utilities

        .target(
            name: "SharedModels",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),

        .target(
            name: "SharedViews",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "StyleGuide",
            ]
        ),

        .target(
            name: "StyleGuide",
            dependencies: [],
            resources: [.process("Fonts")]
        ),

        .target(
            name: "TCAHelpers",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),

        // MARK: - Clients & Services

        .target(
            name: "APIClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                "SharedModels",
            ]
        ),

        .target(
            name: "APIClientLive",
            dependencies: ["APIClient"]
        ),

        .target(
            name: "AuthenticationClient",
            dependencies: [
                "Keychain",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),

        .target(
            name: "Keychain",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "KeychainTests",
            dependencies: ["Keychain"]
        ),

        // MARK: - Testing

        .testTarget(
            name: "SnapshotsTests",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "ConnectWalletFeature",
                "OnboardingFeature",
                "ProfileFeature",
                "Root",
                "SearchFeature",
                "APIClient",
                "APIClientLive"
            ]
        ),
    ]
)
