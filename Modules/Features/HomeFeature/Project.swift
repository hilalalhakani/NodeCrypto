import ProjectDescription

let project = Project(
    name: "HomeFeature",
    targets: [
        .target(
            name: "HomeFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.home",
            sources: ["../../../Packages/Sources/HomeFeature/**"],
            resources: [
                "../../../Packages/Sources/HomeFeature/Resources/**",
            ],
            dependencies: [
                .project(target: "APIClient", path: "../../Foundation/APIClient"),
                .external(name: "ComposableArchitecture"),
                .project(target: "TCAHelpers", path: "../../Foundation/TCAHelpers"),
                .external(name: "Dependencies"),
                .project(target: "SharedModels", path: "../../Foundation/SharedModels"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
                .project(target: "StyleGuide", path: "../../Foundation/StyleGuide"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "HomeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.home.tests",
            sources: ["../../../Packages/Tests/HomeTests/**"],
            dependencies: [
                .target(name: "HomeFeature"),
                .project(target: "SharedModels", path: "../../Foundation/SharedModels"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
