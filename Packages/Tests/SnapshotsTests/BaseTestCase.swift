//
//  File.swift
//
//
//  Created by Hilal Hakkani on 06/08/2024.
//

import ComposableArchitecture
import Foundation
import Keychain
import SharedModels
import SnapshotTesting
import StyleGuide
import SwiftUI
import UIKit
import Testing

extension ViewImageConfig {
    // iPhone 17 (and Pro): 402 × 874 pt logical resolution, 3× scale
    static let iPhone17 = ViewImageConfig.init(
        safeArea: .init(top: 62, left: 0, bottom: 34, right: 0),
        size: .init(width: 402, height: 874),
        traits: .init(displayScale: 3)
    )
}

@MainActor func assert(
    _ view: some View,
    delay: TimeInterval = 0,
    fileID: StaticString = #fileID,
    file filePath: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column,
    named: String = #function
) throws {
    UIFont.registerAllFonts()
    UIView.setAnimationsEnabled(false)
    let viewController = UIHostingController(
        rootView: view.transaction {
            $0.disablesAnimations = true
            $0.animation = nil
        }
    )
    viewController.overrideUserInterfaceStyle = .light

    let strategy: Snapshotting<UIViewController, UIImage> = delay > 0
        ? .wait(for: delay, on: .image(on: .iPhone17, perceptualPrecision: 0.98))
        : .image(on: .iPhone17, perceptualPrecision: 0.98)

    // 1️⃣ Create a custom DiffTool that copies the failed screenshot
    let ciDiffTool = SnapshotTestingConfiguration.DiffTool { currentPath, failedPath in
        let fileManager = FileManager.default
        let sourceURL = URL(fileURLWithPath: "\(filePath)")
        let destDirectory = sourceURL
            .deletingLastPathComponent()
            .appendingPathComponent("FailingSnapshots")

        print("🚨 Intercepted failing snapshot, saving to: \(destDirectory.path)")

        let failedDirectory = destDirectory.appendingPathComponent("failed")
        let referenceDirectory = destDirectory.appendingPathComponent("reference")

        try? fileManager.createDirectory(at: failedDirectory, withIntermediateDirectories: true)
        try? fileManager.createDirectory(at: referenceDirectory, withIntermediateDirectories: true)

        let fileName = URL(fileURLWithPath: currentPath).lastPathComponent
        let failedDestURL = failedDirectory.appendingPathComponent(fileName)
        let referenceDestURL = referenceDirectory.appendingPathComponent(fileName)

        // Copy both images
        try? fileManager.removeItem(at: failedDestURL)
        try? fileManager.copyItem(at: URL(fileURLWithPath: failedPath), to: failedDestURL)

        try? fileManager.removeItem(at: referenceDestURL)
        try? fileManager.copyItem(at: URL(fileURLWithPath: currentPath), to: referenceDestURL)

        // Fallback to printing paths in console (matches default DiffTool behavior)
        return SnapshotTestingConfiguration.DiffTool.default(currentFilePath: currentPath, failedFilePath: failedPath)
    }

    withSnapshotTesting(diffTool: ciDiffTool) {
        assertSnapshot(
            of: viewController,
            as: strategy,
            named: named,
            fileID: fileID,
            file: filePath,
            testName: named,
            line: line,
            column: column
        )
    }

    // Fix: SnapshotTesting retains the viewController in a global UIWindow.
    // This prevents the TCA Store from deallocating, which causes any infinite
    // .run effects (like Combine publisher streams) to leak and hang Swift Testing.
    if let window = viewController.view.window {
        window.rootViewController = nil
        // Also setting it to a dummy UIViewController to ensure clean deallocation
        window.rootViewController = UIViewController()
    }
}

