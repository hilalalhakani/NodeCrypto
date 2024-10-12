//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 26/05/2024.
//

import Foundation
import SwiftUI

public struct AboutMeItem: Identifiable, Equatable, Hashable, Sendable {
    public let title: String
    public let count: String
    public let iconName: String
    public let id: UUID

    public init(title: String, count: String, iconName: String, id: UUID) {
        self.title = title
        self.count = count
        self.iconName = iconName
        self.id = id
    }
}
