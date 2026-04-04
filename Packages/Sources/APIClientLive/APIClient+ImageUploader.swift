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

    public static func live(baseURL: URL) -> Self {
        @Dependency(\.urlSession) var urlSession

        return .init { imageData in
            let url = baseURL.appendingPathComponent("api/images/upload")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue(
                "multipart/form-data; boundary=\(boundary)",
                forHTTPHeaderField: "Content-Type"
            )

            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append(
                "Content-Disposition: form-data; name=\"image\"; filename=\"image.jpeg\"\r\n"
                    .data(using: .utf8)!
            )
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = body

            let (data, _) = try await urlSession.data(for: request)

            struct UploadResponse: Decodable {
                let url: String
            }

            let result = try JSONDecoder().decode(UploadResponse.self, from: data)
            return result.url
        }
    }
    public static func mock() -> Self {
        return .init { _ in
            try await APIClient.mimic("https://dummyimage.com/600x400/000/fff")
        }
    }
}
