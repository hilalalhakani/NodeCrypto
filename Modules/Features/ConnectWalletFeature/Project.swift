import ProjectDescription

let project = Project(
    name: "ConnectWalletFeature",
    targets: [
        .target(
            name: "ConnectWalletFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.connect-wallet",
            sources: ["../../../Packages/Sources/ConnectWalletFeature/**"],
            resources: [
                "../../../Packages/Sources/ConnectWalletFeature/Resources/**",
            ],
            dependencies: [
                .project(target: "APIClient", path: "../../Foundation/APIClient"),
                .project(target: "AuthenticationClient", path: "../../Foundation/AuthenticationClient"),
                .project(target: "Keychain", path: "../../Foundation/Keychain"),
                .project(target: "StyleGuide", path: "../../Foundation/StyleGuide"),
                .project(target: "TCAHelpers", path: "../../Foundation/TCAHelpers"),
                .external(name: "DependenciesAdditions"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "ConnectWalletFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.connect-wallet.tests",
            sources: ["../../../Packages/Tests/ConnectWalletFeatureTests/**"],
            dependencies: [
                .target(name: "ConnectWalletFeature"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
