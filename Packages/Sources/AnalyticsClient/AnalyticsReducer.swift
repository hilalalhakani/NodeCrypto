//
//  File.swift
//
//
//  Created by HH on 24/06/2023.
//

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

public struct AnalyticsReducer<State, Action>: Reducer {
    let toAnalyticsData: (State, Action) -> AnalyticsData?
    @Dependency(\.analyticsClient) var analyticsClient

    public init(_ toAnalyticsData: @escaping (State, Action) -> AnalyticsData?) {
        self.init(toAnalyticsData: toAnalyticsData, internal: ())
    }

    init(toAnalyticsData: @escaping (State, Action) -> AnalyticsData?, internal _: Void) {
        self.toAnalyticsData = toAnalyticsData
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        guard let analyticsData = toAnalyticsData(state, action) else {
            return .none
        }

        return .run { _ in
            analyticsClient.sendAnalytics(analyticsData)
        }
    }
}
