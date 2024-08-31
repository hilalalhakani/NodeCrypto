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
    public var fullName: String
    public var mobileNumber: String
    public var profileImage: String
    public var walletAddress: String
    public var profileDescription: String

    public init(
        id: UUID,
        email: String,
        fullName: String,
        mobileNumber: String,
        profileImage: String,
        walletAddress: String,
        profileDescription: String
    ) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.mobileNumber = mobileNumber
        self.profileImage = profileImage
        self.walletAddress = walletAddress
        self.profileDescription = profileDescription
    }
}

extension User {
    public static var mock1: User {
        User(
            id: .init(uuidString: "00000000-0000-0000-0000-000000000001")!,
            email: "bob@gmail.com",
            fullName: "John Doe",
            mobileNumber: "96171123456",
            profileImage: "https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_0.jpg",
            walletAddress: "0x12324daadsd",
            profileDescription: "Hello world, I'm John from Japan. I create beautiful stuff"
        )
    }
}
