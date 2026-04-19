import ProjectDescription

let project = Project(
    name: "AuthenticationClient",
    targets: [
        .target(
            name: "AuthenticationClient",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.auth-client",
            sources: ["../../../Packages/Sources/AuthenticationClient/**"],
            dependencies: [
                .project(target: "Keychain", path: "../Keychain"),
                .external(name: "FirebaseAuth"),
                .project(target: "SharedModels", path: "../SharedModels"),
                .external(name: "ComposableArchitecture"),
                .external(name: "Dependencies"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
    ]
)
