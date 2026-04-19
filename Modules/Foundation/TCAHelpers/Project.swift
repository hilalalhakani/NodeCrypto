import ProjectDescription

let project = Project(
    name: "TCAHelpers",
    targets: [
        .target(
            name: "TCAHelpers",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.tca-helpers",
            sources: ["../../../Packages/Sources/TCAHelpers/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
    ]
)
