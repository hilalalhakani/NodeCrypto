//
//  File 2.swift
//  
//
//  Created by Hilal Hakkani on 01/09/2024.
//

import Foundation

public struct Notification: Sendable, Codable {
    public let senderName: String
    public let senderImageURLString: String
    public let date: String
    public let id: UUID

    public init(senderName: String, senderImageURLString: String, date: String, id: UUID = .init()) {
        self.senderName = senderName
        self.senderImageURLString = senderImageURLString
        self.date = date
        self.id = id
    }
}

extension Notification: Identifiable, Equatable {}
