import APIClient
import Dependencies
import Foundation

public enum SimulationConfig {
    public static let delay: Duration = .seconds(1)
}

extension APIClient: DependencyKey {
    public static var liveValue: APIClient {
        .init(connectWallet: .mock(), profile: .mock(), home: .mock(), imageUploader: .live())
    }
}

extension APIClient {
    public static func mimic<T: Sendable>(_ value: @Sendable @autoclosure () -> T) async throws -> T {
        @Dependency(\.continuousClock) var clock
        try await clock.sleep(for: SimulationConfig.delay)
        return value()
    }
}
