import ProjectDescription

let project = Project(
    name: "Keychain",
    targets: [
        .target(
            name: "Keychain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.keychain",
            sources: ["../../../Packages/Sources/Keychain/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "Dependencies"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "KeychainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.keychain.tests",
            sources: ["../../../Packages/Tests/KeychainTests/**"],
            dependencies: [
                .target(name: "Keychain"),
            ]
        ),
    ]
)
