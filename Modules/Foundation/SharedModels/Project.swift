import ProjectDescription

let project = Project(
    name: "SharedModels",
    targets: [
        .target(
            name: "SharedModels",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.shared-models",
            sources: ["../../../Packages/Sources/SharedModels/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "Dependencies"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
    ]
)
