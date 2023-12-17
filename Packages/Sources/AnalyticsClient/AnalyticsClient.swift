//
//  File.swift
//
//
//  Created by HH on 24/06/2023.
//

import Foundation

public struct AnalyticsClient {
    public var sendAnalytics: @Sendable (AnalyticsData) -> Void

    public init(sendAnalytics: @escaping @Sendable (AnalyticsData) -> Void) {
        self.sendAnalytics = sendAnalytics
    }
}

public extension AnalyticsClient {
    static func merge(_ clients: AnalyticsClient...) -> Self {
        .init { data in
            clients.forEach { $0.sendAnalytics(data) }
        }
    }
}

extension AnalyticsClient {
    public static var consoleLogger: Self = .init(
        sendAnalytics: { analytics in
            #if DEBUG
                print("[Analytics] ✅ \(analytics)")
            #endif
        }
    )
}
