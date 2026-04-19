import ProjectDescription

let project = Project(
    name: "SnapshotsTests",
    targets: [
        .target(
            name: "SnapshotsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.nodecrypto.snapshots",
            sources: ["../../Packages/Tests/SnapshotsTests/**"],
            dependencies: [
                .external(name: "SnapshotTesting"),
                .external(name: "ComposableArchitecture"),
                .external(name: "DependenciesTestSupport"),
                .project(target: "AppFeature", path: "../../Modules/AppShell/AppFeature"),
                .project(target: "APIClientLive", path: "../../Modules/Foundation/APIClientLive"),
                .project(target: "CreateFeature", path: "../../Modules/Features/CreateFeature"),
                .project(target: "HomeFeature", path: "../../Modules/Features/HomeFeature"),
                .project(target: "ProfileFeature", path: "../../Modules/Features/ProfileFeature"),
                .project(target: "SearchFeature", path: "../../Modules/Features/SearchFeature"),
                .project(target: "NotificationsFeature", path: "../../Modules/Features/NotificationsFeature"),
                .project(target: "ConnectWalletFeature", path: "../../Modules/Features/ConnectWalletFeature"),
                .project(target: "Keychain", path: "../../Modules/Foundation/Keychain"),
                .project(target: "SharedModels", path: "../../Modules/Foundation/SharedModels"),
                .project(target: "StyleGuide", path: "../../Modules/Foundation/StyleGuide"),
                .project(target: "Root", path: "../../Modules/AppShell/Root"),
            ]
        ),
    ]
)
