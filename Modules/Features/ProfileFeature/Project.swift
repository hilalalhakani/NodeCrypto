import ProjectDescription

let project = Project(
    name: "ProfileFeature",
    targets: [
        .target(
            name: "ProfileFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.profile",
            sources: ["../../../Packages/Sources/ProfileFeature/**"],
            resources: [
                "../../../Packages/Sources/ProfileFeature/Resources/**",
            ],
            dependencies: [
                .project(target: "Keychain", path: "../../Foundation/Keychain"),
                .project(target: "AuthenticationClient", path: "../../Foundation/AuthenticationClient"),
                .external(name: "ComposableArchitecture"),
                .project(target: "StyleGuide", path: "../../Foundation/StyleGuide"),
                .project(target: "APIClient", path: "../../Foundation/APIClient"),
                .project(target: "TCAHelpers", path: "../../Foundation/TCAHelpers"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "ProfileTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.profile.tests",
            sources: ["../../../Packages/Tests/ProfileTests/**"],
            dependencies: [
                .target(name: "ProfileFeature"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
