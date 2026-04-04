import APIClient
import Dependencies
import Foundation

public enum SimulationConfig {
    public static let delay: Duration = .seconds(1)
}

extension APIClient {
    public static func mimic<T: Sendable>(_ value: @Sendable @autoclosure () -> T) async throws -> T {
        @Dependency(\.continuousClock) var clock
        try await clock.sleep(for: SimulationConfig.delay)
        return value()
    }
}
