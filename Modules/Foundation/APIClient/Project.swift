import ProjectDescription

let project = Project(
    name: "APIClient",
    targets: [
        .target(
            name: "APIClient",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.api-client",
            sources: ["../../../Packages/Sources/APIClient/**"],
            dependencies: [
                .external(name: "Dependencies"),
                .project(target: "SharedModels", path: "../SharedModels"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
    ]
)
