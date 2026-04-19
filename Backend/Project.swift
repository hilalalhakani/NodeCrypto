import ProjectDescription

let project = Project(
    name: "NodeCryptoServer",
    targets: [
        .target(
            name: "NodeCryptoServer",
            destinations: .macOS,
            product: .app,
            bundleId: "com.nodecrypto.server",
            sources: ["Sources/NodeCryptoServer/**"],
            dependencies: [],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "MACOSX_DEPLOYMENT_TARGET": "14.0",
                ]
            )
        ),
    ]
)
