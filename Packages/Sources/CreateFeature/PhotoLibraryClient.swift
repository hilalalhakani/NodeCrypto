//
//  PhotoLibraryClient.swift
//  Main
//
//  Created by Hilal Hakkani on 29/06/2025.
//

import Dependencies
import SwiftUI
import Photos
#if canImport(UIKit)
import UIKit
#endif
import ComposableArchitecture

@DependencyClient
public struct PhotoLibraryClient: Sendable {
    public var fetchImages: @Sendable () async throws -> [(Image, Data)]
}

extension PhotoLibraryClient: DependencyKey {
    public static let liveValue = Self(
        fetchImages: {
            await Task.detached(priority: .userInitiated) {
                var images: [(Image, Data)] = []

                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 10
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                let imageManager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .highQualityFormat
                requestOptions.isNetworkAccessAllowed = true

                for i in 0..<allPhotos.count {
                    let asset = allPhotos.object(at: i)
                    let result: (Image, Data)? = await withCheckedContinuation { continuation in
                        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions) { uiImage, _ in
                            if let uiImage = uiImage, let data = uiImage.pngData() {
                                let image = Image(uiImage: uiImage)
                                continuation.resume(returning: (image, data))
                            } else {
                                continuation.resume(returning: nil)
                            }
                        }
                    }
                    
                    if let result {
                        images.append(result)
                    }
                }
                return images
            }.value
        }
    )
}

extension DependencyValues {
    public var photoLibraryClient: PhotoLibraryClient {
        get { self[PhotoLibraryClient.self] }
        set { self[PhotoLibraryClient.self] = newValue }
    }
}
