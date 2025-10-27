//
//  APIClient+ImageUploader.swift
//  Main
//
//  Created by Hilal Hakkani on 19/10/2025.
//

import APIClient
import Foundation
import Dependencies

extension APIClient.ImageUploader {
    public static func live() -> Self {
        @Dependency(\.urlSession) var urlSession
        return .init(
            { imageData in
                let url = URL(string: "https://sm.ms/api/v2/upload")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue(
                    "multipart/form-data; boundary=\(boundary)",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue("aoGVXFYF2cYPrgENFOkRaMwysNoMBpS1", forHTTPHeaderField: "Authorization")

                var body = Data()
                let fileName = UUID().uuidString
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append(
                    "Content-Disposition: form-data; name=\"smfile\"; filename=\"\(fileName).jpeg\"\r\n"
                        .data(using: .utf8)!
                )
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)

                body.append("--\(boundary)--\r\n".data(using: .utf8)!)

                request.httpBody = body

                let (data, _) = try await urlSession.data(for: request)
                let uploadImageResponse = try JSONDecoder().decode(UploadImageResponse.self, from: data)
                return uploadImageResponse.data.url
            }
        )
    }
}
