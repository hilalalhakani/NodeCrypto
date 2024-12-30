import Dependencies

extension DependencyValues {
    public var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

public struct APIClient: Sendable {
    public var connectWallet: ConnectWallet
    public var profile: Profile
    public var home: Home
}

extension APIClient {
    static var unimplemented: APIClient {
        .init(
            connectWallet: .unimplemented,
            profile: .unimplemented,
            home: .unimplemented
        )
    }
}

extension APIClient: DependencyKey {
    public static var testValue: APIClient { .unimplemented }
    public static var previewValue: APIClient { .unimplemented }
    public static var liveValue: APIClient { .init(connectWallet: .mock(), profile: .mock(), home: .mock()) }
}
