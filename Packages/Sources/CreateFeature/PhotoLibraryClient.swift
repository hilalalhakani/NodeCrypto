//
//  PhotoLibraryClient.swift
//  Main
//
//  Created by Hilal Hakkani on 29/06/2025.
//

import Dependencies
import SwiftUI
import Photos
import UIKit
import ComposableArchitecture

@DependencyClient
public struct PhotoLibraryClient: Sendable {
    public var fetchImages: @Sendable () async throws -> [(Image, Data)]
}

extension PhotoLibraryClient: DependencyKey {
    public static let liveValue = Self {
        var images: [(Image, Data)] = []

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat

        for i in 0..<allPhotos.count {
            let asset = allPhotos.object(at: i)
            await withCheckedContinuation { continuation in
                imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions) {
                    uiImage, _ in
                    if let uiImage = uiImage {
                        let image = Image(uiImage: uiImage)
                        if let data = uiImage.pngData() {
                            images.append((image, data))
                        }
                    }
                    continuation.resume()
                }
            }
        }
        return images
    }
}

extension DependencyValues {
    public var photoLibraryClient: PhotoLibraryClient {
        get { self[PhotoLibraryClient.self] }
        set { self[PhotoLibraryClient.self] = newValue }
    }
}
