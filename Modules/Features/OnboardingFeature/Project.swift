import ProjectDescription

let project = Project(
    name: "OnboardingFeature",
    targets: [
        .target(
            name: "OnboardingFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.nodecrypto.onboarding",
            sources: ["../../../Packages/Sources/OnboardingFeature/**"],
            resources: [
                "../../../Packages/Sources/OnboardingFeature/Resources/**",
            ],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "TCAHelpers", path: "../../Foundation/TCAHelpers"),
                .project(target: "StyleGuide", path: "../../Foundation/StyleGuide"),
                .project(target: "SharedViews", path: "../../Foundation/SharedViews"),
            ],
            settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"])
        ),
        .target(
            name: "OnboardingFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.onboarding.tests",
            sources: ["../../../Packages/Tests/OnboardingFeatureTests/**"],
            dependencies: [
                .target(name: "OnboardingFeature"),
                .external(name: "CustomDump"),
                .external(name: "DependenciesTestSupport"),
            ]
        ),
    ]
)
