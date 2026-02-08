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
        return .init(
            { walletType, deviceId in
                if walletType == .rainbow { throw APIClient.ConnectWallet.Error.accountNotFound }
                return try await APIClient.mimic(User.mock1)
            }
        )
    }
}
