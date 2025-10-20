//
//  APIClient+ConnectWallet.swift
//  Main
//
//  Created by Hilal Hakkani on 19/10/2025.
//

import Dependencies
import APIClient

extension APIClient.ConnectWallet {
    public static func mock() -> Self {
        @Dependency(\.continuousClock) var clock
        return .init(
            { walletType, deviceId in
                try await clock.sleep(for: .milliseconds(500))
                if walletType == .rainbow { throw APIClient.ConnectWallet.Error.accountNotFound}
                return User.mock1
            }
        )
    }
}
