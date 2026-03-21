import Foundation
import ComposableArchitecture

// MARK: - AnalyticsData

public enum AnalyticsData: Equatable, Sendable {
    case event(name: String, properties: [String: String] = [:])
    case screen(name: String)
    case userId(String)
    case userProperty(name: String, value: String)
    case error(Error)

    public static func == (lhs: AnalyticsData, rhs: AnalyticsData) -> Bool {
        switch (lhs, rhs) {
        case let (.event(lhsName, lhsProps), .event(rhsName, rhsProps)):
            return lhsName == rhsName && lhsProps == rhsProps
        case let (.screen(lhsName), .screen(rhsName)):
            return lhsName == rhsName
        case let (.userId(lhsId), .userId(rhsId)):
            return lhsId == rhsId
        case let (.userProperty(name: lhsName, value: lhsValue), .userProperty(name: rhsName, value: rhsValue)):
            return lhsName == rhsName && lhsValue == rhsValue
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

extension AnalyticsData: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .event(name: value, properties: [:])
    }
}

// MARK: - AnalyticsClient

public struct AnalyticsClient: Sendable {
    public var sendAnalytics: @Sendable (AnalyticsData) -> Void

    public init(sendAnalytics: @escaping @Sendable (AnalyticsData) -> Void) {
        self.sendAnalytics = sendAnalytics
    }
}

extension AnalyticsClient {
    public static func merge(_ clients: AnalyticsClient...) -> Self {
        .init { data in
            clients.forEach { $0.sendAnalytics(data) }
        }
    }

    public nonisolated(unsafe) static var consoleLogger: Self = .init(
        sendAnalytics: { analytics in
#if DEBUG
            print("[Analytics] ✅ \(analytics)")
#endif
        }
    )

    public nonisolated(unsafe) static var noop: Self = .init(sendAnalytics: { _ in })
}

// MARK: - Test Support

extension AnalyticsClient {
    /// Mutates the client so that it asserts the next analytics event matches
    /// `expectedAnalytics`. Call this on `store.dependencies.analyticsClient`
    /// before sending an action that should fire analytics.
    public mutating func expect(_ expectedAnalytics: AnalyticsData?) {
        let previous = self.sendAnalytics
        self.sendAnalytics = { @Sendable received in
            if let expected = expectedAnalytics {
                assert(
                    received == expected,
                    "Expected analytics '\(expected)' but received '\(received)'"
                )
            } else {
                previous(received)
            }
        }
    }
}

// MARK: - Dependency

extension AnalyticsClient: DependencyKey {
    public static let liveValue: AnalyticsClient = .noop
    public static let testValue: AnalyticsClient = .noop
    public static let previewValue: AnalyticsClient = .consoleLogger
}

public extension DependencyValues {
    var analyticsClient: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}

// MARK: - AnalyticsReducer

public struct AnalyticsReducer<State, Action>: Reducer, @unchecked Sendable {
    @usableFromInline
    let toAnalyticsData: (State, Action) -> AnalyticsData?

    @usableFromInline
    @Dependency(\.analyticsClient) var analyticsClient

    @inlinable
    public init(_ toAnalyticsData: @escaping (State, Action) -> AnalyticsData?) {
        self.toAnalyticsData = toAnalyticsData
    }

    @inlinable
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        guard let analyticsData = toAnalyticsData(state, action) else {
            return .none
        }
        let client = analyticsClient
        return .run { _ in
            client.sendAnalytics(analyticsData)
        }
    }
}
