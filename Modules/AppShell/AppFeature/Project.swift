import ProjectDescription

let project = Project(
    name: "AppFeature",
    targets: [
        .target(
            name: "AppFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.app-feature",
            sources: ["../../../Packages/Sources/AppFeature/**"],
            resources: [
                "../../../Packages/Sources/AppFeature/Resources/**",
            ],
            dependencies: [
                .project(target: "Root", path: "../Root"),
                .project(target: "OnboardingFeature", path: "../../Features/OnboardingFeature"),
                .project(target: "ConnectWalletFeature", path: "../../Features/ConnectWalletFeature"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
                .project(target: "SharedModels", path: "../../Foundation/SharedModels"),
                .project(target: "Keychain", path: "../../Foundation/Keychain"),
            ],
            settings: .settings(
                base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"]
            )
        ),
        .target(
            name: "AppFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.app-feature.tests",
            sources: ["../../../Packages/Tests/AppFeatureTests/**"],
            dependencies: [
                .target(name: "AppFeature"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
