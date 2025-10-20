//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 20/07/2024.
import Foundation
import Dependencies
@_exported import SharedModels
import Dependencies

extension APIClient {
    public struct ImageUploader: Sendable {
        public var uploadImage: @Sendable (Data) async throws -> String
        public init(
            _ uploadImage: @escaping @Sendable (Data) async throws -> String = { _ in "" }
        ) {
            self.uploadImage = uploadImage
        }
    }
}
