import ProjectDescription

let project = Project(
    name: "SearchFeature",
    targets: [
        .target(
            name: "SearchFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.search",
            sources: ["../../../Packages/Sources/SearchFeature/**"],
            resources: [
                "../../../Packages/Sources/SearchFeature/Resources/**",
            ],
            dependencies: [
                .project(target: "APIClient", path: "../../Foundation/APIClient"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
                .project(target: "StyleGuide", path: "../../Foundation/StyleGuide"),
                .project(target: "TCAHelpers", path: "../../Foundation/TCAHelpers"),
                .external(name: "ComposableArchitecture"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "SearchFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.search.tests",
            sources: ["../../../Packages/Tests/SearchFeatureTests/**"],
            dependencies: [
                .target(name: "SearchFeature"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ]
)
