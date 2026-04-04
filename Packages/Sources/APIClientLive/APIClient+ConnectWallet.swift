//
//  APIClient+ConnectWallet.swift
//  Main
//
//  Created by Hilal Hakkani on 19/10/2025.
//

import Dependencies
import APIClient
import Foundation

extension APIClient.ConnectWallet {
    public static func mock() -> Self {
        return .init(
            { walletType, deviceId in
                if walletType == .rainbow { throw APIClient.ConnectWallet.Error.accountNotFound }
                return try await APIClient.mimic(User.mock1)
            }
        )
    }

    public static func live(baseURL: URL) -> Self {
        @Dependency(\.urlSession) var urlSession

        return .init { walletType, deviceId in
            let url = baseURL.appendingPathComponent("api/wallet/connect")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = [
                "walletType": walletType.rawValue,
                "deviceId": deviceId,
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, response) = try await urlSession.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                throw APIClient.ConnectWallet.Error.accountNotFound
            }

            return try JSONDecoder().decode(User.self, from: data)
        }
    }
}
