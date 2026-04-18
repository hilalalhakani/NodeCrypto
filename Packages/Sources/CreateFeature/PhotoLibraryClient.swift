//
//  PhotoLibraryClient.swift
//  Main
//
//  Created by Hilal Hakkani on 29/06/2025.
//

import Dependencies
import SwiftUI
import Photos
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
                        imageManager.requestImage(
                            for: asset,
                            targetSize: PHImageManagerMaximumSize,
                            contentMode: .aspectFit,
                            options: requestOptions
                        ) { platformImage, _ in
#if canImport(UIKit)
                            if let uiImage = platformImage, let data = uiImage.pngData() {
                                continuation.resume(returning: (Image(uiImage: uiImage), data))
                            } else {
                                continuation.resume(returning: nil)
                            }
#elseif canImport(AppKit)
                            if let nsImage = platformImage,
                               let tiffData = nsImage.tiffRepresentation,
                               let bitmap = NSBitmapImageRep(data: tiffData),
                               let data = bitmap.representation(using: .png, properties: [:]) {
                                continuation.resume(returning: (Image(nsImage: nsImage), data))
                            } else {
                                continuation.resume(returning: nil)
                            }
#endif
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
