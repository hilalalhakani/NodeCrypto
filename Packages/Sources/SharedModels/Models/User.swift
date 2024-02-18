//
//  File.swift
//
//
//  Created by HH on 09/12/2023.
//

import Combine
import Foundation
//import Dependencies

public struct User: Identifiable, Hashable, Sendable, Codable, Equatable {
    public var id: UUID
    public var email: String
    public var fullName: String = ""
    public var mobileNumber: String = ""
    public var profileImage: ResourceKey<ImageDataResource>?
}

public extension User {
    static var mock1: User {
        User(
            id: .init(uuidString: "00000000-0000-0000-0000-000000000001")!,
            email: "bob@gmail.com",
            fullName: "John Doe",
            mobileNumber: "96171123456",
            profileImage: .init(location: .url(.init(string: "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200")!))
        )
    }
}
