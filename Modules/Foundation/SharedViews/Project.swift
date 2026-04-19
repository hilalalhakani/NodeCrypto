import ProjectDescription

let project = Project(
    name: "SharedViews",
    targets: [
        .target(
            name: "SharedViews",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.shared-views",
            sources: ["../../../Packages/Sources/SharedViews/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "StyleGuide", path: "../StyleGuide"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
    ]
)
