////
////  File.swift
////  
////
////  Created by Hilal Hakkani on 09/04/2024.
////
//
//import Foundation
//import ComposableArchitecture
//import Foundation
//import LocalStorage
//import ResourceProvider
//import SharedModels
//import XCTest
//
// class LocalStorageTests: XCTestCase {
//     @MainActor
//    func test_saveImage() async throws {
//
//        try await withDependencies {
//            $0.date = .constant(Date())
//        } operation: {
//            let storage = LocalStorage.testValue
//            let image = self.generateImage()
//            let imageData = image.pngData()!
//            let resourceKey = ResourceKey<ImageDataResource>(location: .url(self.anyURL()))
//            let imageResource = ImageDataResource(data: imageData)
//            try await storage.set(imageResource, forKey: resourceKey, destination: .cache)
//
//            let fetchedImage = try await storage.get(key: resourceKey)
//            XCTAssertEqual(fetchedImage.data, imageData)
//        }
//
//    }
//
//     @MainActor
//    func test_saveUnknownResource() async throws {
//         await withDependencies {
//            $0.date = .constant(Date())
//        } operation: {
//            let storage = LocalStorage.testValue
//            let resourceKey = ResourceKey<UknownResource>(location: .url(self.anyURL()))
//
//            do {
//                try await storage.set(UknownResource(), forKey: resourceKey, destination: .cache)
//                XCTFail("The resource should not have been saved")
//            } catch (let error) {
//                XCTAssertEqual(error as? LocalStorageError, LocalStorageError.unsupportedType)
//            }
//        }
//    }
//
//     @MainActor
//    func test_delete() async throws {
//
//        try await withDependencies {
//            $0.date = .constant(Date())
//        } operation: {
//            let storage = LocalStorage.testValue
//            let image = self.generateImage()
//            let imageData = image.pngData()!
//            let resourceKey = ResourceKey<ImageDataResource>(location: .url(self.anyURL()))
//            let imageResource = ImageDataResource(data: imageData)
//            try await storage.set(imageResource, forKey: resourceKey, destination: .cache)
//            try await storage.delete(key: resourceKey)
//
//            do {
//                _ = try await storage.get(key: resourceKey)
//                XCTFail("The resource should have been deleted")
//            } catch (let error) {
//                XCTAssertEqual(error as? LocalStorageError, LocalStorageError.noItemFound)
//
//            }
//
//        }
//
//    }
//
//    //MARK: Helpers
//    func generateImage() -> UIImage {
//        let color = UIColor(
//            red: .random(in: 0...1),
//            green: .random(in: 0...1),
//            blue: .random(in: 0...1),
//            alpha: 1.0
//        )
//        let size = CGSize(width: 1, height: 1)
//        return UIGraphicsImageRenderer(size: size).image { rendererContext in
//            color.setFill()
//            rendererContext.fill(CGRect(origin: .zero, size: size))
//        }
//    }
//
//    func anyURL() -> URL {
//        URL(string: "www.anyURL.com")!
//    }
//
//    private struct UknownResource {}
//}
