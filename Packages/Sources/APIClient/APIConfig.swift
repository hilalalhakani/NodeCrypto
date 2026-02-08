import Dependencies
import Foundation

public struct APIConfig: Sendable {
    public var baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

extension APIConfig: DependencyKey {
    public static var liveValue: APIConfig {
        #if DEBUG
        return Self(baseURL: URL(string: "https://dev-api.example.com")!)
        #else
        return Self(baseURL: URL(string: "https://api.example.com")!)
        #endif
    }

    public static var testValue: APIConfig {
        return Self(baseURL: URL(string: "https://test-api.example.com")!)
    }
}

extension DependencyValues {
    public var apiConfig: APIConfig {
        get { self[APIConfig.self] }
        set { self[APIConfig.self] = newValue }
    }
}
