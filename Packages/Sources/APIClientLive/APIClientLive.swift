//
//  APIClientLive.swift
//  Main
//
//  Created by Hilal Hakkani on 19/10/2025.
//

import APIClient
import Dependencies

extension APIClient: DependencyKey {
    public static var liveValue: APIClient {
        .init(connectWallet: .mock(), profile: .mock(), home: .mock(), imageUploader: .live())
    }
}
