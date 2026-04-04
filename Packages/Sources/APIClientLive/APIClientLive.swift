import APIClient
import Dependencies
import Foundation

extension APIClient {
    public static func liveValue(baseURL: URL) -> APIClient {
        .init(
            connectWallet: .live(baseURL: baseURL),
            profile: .live(baseURL: baseURL),
            home: .live(baseURL: baseURL),
            imageUploader: .live(baseURL: baseURL)
        )
    }

    public static var mockValue: APIClient {
        .init(
            connectWallet: .mock(),
            profile: .mock(),
            home: .mock(),
            imageUploader: .mock()
        )
    }
}
