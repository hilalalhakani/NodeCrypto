import ProjectDescription

let project = Project(
    name: "APIClientLive",
    targets: [
        .target(
            name: "APIClientLive",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.api-client-live",
            sources: ["../../../Packages/Sources/APIClientLive/**"],
            dependencies: [
                .project(target: "APIClient", path: "../APIClient"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
    ]
)
