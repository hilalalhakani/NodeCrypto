import ProjectDescription

let project = Project(
    name: "Root",
    targets: [
        .target(
            name: "Root",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.root",
            sources: ["../../../Packages/Sources/Root/**"],
            resources: [
                "../../../Packages/Sources/Root/Media.xcassets/**",
                "../../../Packages/Sources/Root/en.lproj",
                "../../../Packages/Sources/Root/fr.lproj",
            ],
            dependencies: [
                .project(target: "HomeFeature", path: "../../Features/HomeFeature"),
                .project(target: "ProfileFeature", path: "../../Features/ProfileFeature"),
                .project(target: "NotificationsFeature", path: "../../Features/NotificationsFeature"),
                .project(target: "SearchFeature", path: "../../Features/SearchFeature"),
                .project(target: "CreateFeature", path: "../../Features/CreateFeature"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "RootTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.root.tests",
            sources: ["../../../Packages/Tests/RootTests/**"],
            dependencies: [
                .target(name: "Root"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
