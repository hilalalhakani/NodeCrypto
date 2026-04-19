import ProjectDescription

let infoPlist: InfoPlist = .extendingDefault(
    with: [
        "CFBundleLocalizations": .array([.string("en"), .string("fr")]),
        "UILaunchScreen": .dictionary([
            "UIImageName": .string("SplashScreen"),
        ]),
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsLocalNetworking": .boolean(true),
        ]),
    ]
)

let appTarget: Target = .target(
    name: "NodeCrypto",
    destinations: .iOS,
    product: .app,
    bundleId: "home.iOS",
    infoPlist: infoPlist,
    sources: ["../NodeCrypto/NodeCrypto/**"],
    resources: [
        "../NodeCrypto/NodeCrypto/Assets.xcassets/**",
        "../NodeCrypto/NodeCrypto/Preview Content/**",
    ],
    entitlements: .file(path: "../NodeCrypto/NodeCrypto/NodeCrypto.entitlements"),
    dependencies: [
        .project(target: "AppFeature", path: "../Modules/AppShell/AppFeature"),
        .project(target: "APIClientLive", path: "../Modules/Foundation/APIClientLive"),
    ],
    settings: .settings(
        base: [
            "GENERATE_INFOPLIST_FILE": "YES",
            "INFOPLIST_KEY_UIApplicationSceneManifest_Generation": "YES",
            "INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents": "YES",
            "INFOPLIST_KEY_UISupportedInterfaceOrientations": "UIInterfaceOrientationPortrait",
            "INFOPLIST_KEY_UISupportedInterfaceOrientations~ipad": "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
            "CODE_SIGN_STYLE": "Automatic",
            "CURRENT_PROJECT_VERSION": "1",
            "MARKETING_VERSION": "1.0",
            "SWIFT_VERSION": "6.0",
            "TARGETED_DEVICE_FAMILY": "1,2",
            "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
        ]
    )
)

let nodeScheme: Scheme = .scheme(
    name: "NodeCrypto",
    buildAction: .buildAction(targets: [.target("NodeCrypto")]),
    testAction: .targets([
        "AppFeatureTests",
        "RootTests",
        "HomeTests",
        "ProfileTests",
        "SearchFeatureTests",
        "CreateFeatureTests",
        "OnboardingFeatureTests",
        "NotificationsFeatureTests",
        "ConnectWalletFeatureTests",
        "KeychainTests",
    ]),
    runAction: .runAction(configuration: .debug)
)

let project = Project(
    name: "NodeCrypto",
    targets: [appTarget],
    schemes: [nodeScheme]
)
