import ProjectDescription

let project = Project(
    name: "NotificationsFeature",
    targets: [
        .target(
            name: "NotificationsFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.notifications",
            sources: ["../../../Packages/Sources/NotificationsFeature/**"],
            resources: [
                "../../../Packages/Sources/NotificationsFeature/Resources/**",
            ],
            dependencies: [
                .project(target: "Keychain", path: "../../Foundation/Keychain"),
                .project(target: "AuthenticationClient", path: "../../Foundation/AuthenticationClient"),
                .project(target: "APIClient", path: "../../Foundation/APIClient"),
                .project(target: "TCAHelpers", path: "../../Foundation/TCAHelpers"),
                .project(target: "StyleGuide", path: "../../Foundation/StyleGuide"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
                .external(name: "ComposableArchitecture"),
                .external(name: "Dependencies"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "NotificationsFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.notifications.tests",
            sources: ["../../../Packages/Tests/NotificationsFeatureTests/**"],
            dependencies: [
                .target(name: "NotificationsFeature"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
