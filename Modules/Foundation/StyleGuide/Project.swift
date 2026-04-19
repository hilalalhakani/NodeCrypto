import ProjectDescription

let project = Project(
    name: "StyleGuide",
    targets: [
        .target(
            name: "StyleGuide",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.styleguide",
            sources: ["../../../Packages/Sources/StyleGuide/**"],
            resources: [
                "../../../Packages/Sources/StyleGuide/Fonts/**/*.ttf",
                "../../../Packages/Sources/StyleGuide/Media.xcassets/**",
            ],
            dependencies: [],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
    ]
)
