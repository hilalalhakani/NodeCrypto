//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 24/06/2024.
//

import Foundation

public struct UploadImageResponse: Codable {
    public let success: Bool
    public let code, message: String
    public let data: UploadImageResponseData
    public let requestID: String

    enum CodingKeys: String, CodingKey {
        case success, code, message, data
        case requestID = "RequestId"
    }
}

public struct UploadImageResponseData: Codable {
    public let fileID, width, height: Int
    public let filename, storename: String
    public let size: Int
    public let path, hash: String
    public let url: String
    public let delete, page: String

    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case width, height, filename, storename, size, path, hash, url, delete, page
    }
}
