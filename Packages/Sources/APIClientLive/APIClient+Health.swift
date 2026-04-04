import APIClient
import Dependencies
import Foundation

extension APIClient {
    public static func healthLive(baseURL: URL) -> @Sendable () async throws -> String {
        return {
            let url = baseURL.appendingPathComponent("api/health")
            @Dependency(\.urlSession) var urlSession
            let (data, _) = try await urlSession.data(from: url)
            return String(decoding: data, as: UTF8.self)
        }
    }
    
    public static func healthMock() -> @Sendable () async throws -> String {
        return { "OK" }
    }
}
