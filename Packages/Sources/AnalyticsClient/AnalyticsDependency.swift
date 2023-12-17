//
//  File.swift
//
//
//  Created by HH on 24/06/2023.
//

import ComposableArchitecture
import Foundation

extension AnalyticsClient: DependencyKey {
    public static let liveValue: AnalyticsClient = .consoleLogger
    public static let testValue: AnalyticsClient = .consoleLogger
    public static let previewValue: AnalyticsClient = .consoleLogger
}

public extension DependencyValues {
    var analyticsClient: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}
