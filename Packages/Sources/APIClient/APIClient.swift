@_exported import DependenciesMacros
@_exported import Dependencies

@DependencyClient
public struct APIClient {
    public var connectWallet: ConnectWallet
    public var profile: Profile
    public var home: Home
    public var imageUploader: ImageUploader

    public init(
        connectWallet: ConnectWallet,
        profile: Profile,
        home: Home,
        imageUploader: ImageUploader
    ) {
        self.connectWallet = connectWallet
        self.profile = profile
        self.home = home
        self.imageUploader = imageUploader
    }
}

extension APIClient: Sendable, TestDependencyKey {
    public static let testValue = Self(
        connectWallet: .init(),
        profile: .init(),
        home: .init(),
        imageUploader: .init() 
    )
}

extension DependencyValues {
    public var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
