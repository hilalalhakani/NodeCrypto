import ProjectDescription

let project = Project(
    name: "CreateFeature",
    targets: [
        .target(
            name: "CreateFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.create",
            sources: ["../../../Packages/Sources/CreateFeature/**"],
            resources: [
                "../../../Packages/Sources/CreateFeature/Resources/**",
            ],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
                .project(target: "TCAHelpers", path: "../../Foundation/TCAHelpers"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "CreateFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.create.tests",
            sources: ["../../../Packages/Tests/CreateFeatureTests/**"],
            dependencies: [
                .target(name: "CreateFeature"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
