//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 20/07/2024.
//

import Foundation
import Dependencies
import SharedModels

extension DependencyValues {
    public var imageUploader: ImageUploader {
        get { self[ImageUploader.self] }
        set { self[ImageUploader.self] = newValue }
    }
}

public struct ImageUploader: Sendable {
    public var uploadImage: @Sendable (Data) async throws -> String
}

 

extension ImageUploader: DependencyKey {
    public static var liveValue: ImageUploader {
        self.live()
    }

    public static var testValue: ImageUploader {
        self.unimplemented
    }

    public static var previewValue: ImageUploader {
        self.unimplemented
    }

    public static var unimplemented: Self {
        .init(
            uploadImage: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.imageUploader).uploadImage"#
            )
        )
    }

    public static func live() -> Self {
        @Dependency(\.urlSession) var urlSession
        return .init(
            uploadImage: { imageData in
                let url = URL(string: "https://sm.ms/api/v2/upload")!
                // Create the URL request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue(
                    "multipart/form-data; boundary=\(boundary)",
                    forHTTPHeaderField: "Content-Type"
                )
                request.setValue("aoGVXFYF2cYPrgENFOkRaMwysNoMBpS1", forHTTPHeaderField: "Authorization")

                // Create the body
                var body = Data()
                let fileName = UUID().uuidString
                // Add file data
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append(
                    "Content-Disposition: form-data; name=\"smfile\"; filename=\"\(fileName).jpeg\"\r\n"
                        .data(using: .utf8)!
                )
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)

                // Add closing boundary
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)

                request.httpBody = body

                // Create a data task
                let (data, _) = try await urlSession.data(for: request)
                let uploadImageResponse = try JSONDecoder().decode(UploadImageResponse.self, from: data)
                return uploadImageResponse.data.url
            }
        )
    }
}
