//
//  BaseTestCase.swift
//
//
//  Created by Hilal Hakkani on 06/08/2024.
//

#if os(iOS)
import ComposableArchitecture
import DependenciesTestSupport
import Foundation
import Keychain
import ProfileFeature
import Root
import SharedModels
import SnapshotTesting
import StyleGuide
import SwiftUI
import Testing
import UIKit

// MARK: - Device Config

extension ViewImageConfig {
    // iPhone 17 (and Pro): 402 × 874 pt logical resolution, 3× scale
    static let iPhone17 = ViewImageConfig(
        safeArea: .init(top: 62, left: 0, bottom: 34, right: 0),
        size: .init(width: 402, height: 874),
        traits: .init(displayScale: 3)
    )

    static let iPhone17Dark: ViewImageConfig = .iPhone17
}

// MARK: - Assertion Helper

@MainActor func assert(
    _ view: some View,
    userInterfaceStyle: UIUserInterfaceStyle = .light,
    delay: TimeInterval = 0,
    fileID: StaticString = #fileID,
    file filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    named: String = #function
) throws {
    UIFont.registerAllFonts()
    UIView.setAnimationsEnabled(false)
    let viewController = UIHostingController(
        rootView: view.transaction { configuration in
            configuration.disablesAnimations = true
            configuration.animation = nil
        }
    )
    viewController.overrideUserInterfaceStyle = userInterfaceStyle

    let baseStrategy = ViewImageConfig.iPhone17
    let strategy: Snapshotting<UIViewController, UIImage> = delay > 0
        ? .wait(for: delay, on: .image(on: baseStrategy, perceptualPrecision: 0.98))
        : .image(on: baseStrategy, perceptualPrecision: 0.98)

    // Custom DiffTool that copies failing/reference images for easy review
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

        try? fileManager.removeItem(at: failedDestURL)
        try? fileManager.copyItem(at: URL(fileURLWithPath: failedPath), to: failedDestURL)

        try? fileManager.removeItem(at: referenceDestURL)
        try? fileManager.copyItem(at: URL(fileURLWithPath: currentPath), to: referenceDestURL)

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

    // SnapshotTesting retains the viewController in a global UIWindow.
    // Clearing rootViewController prevents TCA Store deallocation leaks
    // that cause infinite .run effects to hang Swift Testing.
    if let window = viewController.view.window {
        window.rootViewController = nil
        window.rootViewController = UIViewController()
    }
}
#endif
