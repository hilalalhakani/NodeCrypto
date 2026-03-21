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
import SwiftUI
import UIKit
import Testing

let precision: Float = 0.8

extension ViewImageConfig {
    // iPhone 16 Pro: 393 × 852 pt logical resolution, 3× scale
    static let iPhone16Pro = ViewImageConfig.init(
        safeArea: .init(top: 59, left: 0, bottom: 34, right: 0),
        size: .init(width: 393, height: 852),
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
    UIView.setAnimationsEnabled(false)
    let viewController = UIHostingController(
        rootView: view.transaction{
            $0.disablesAnimations = true
            $0.animation = nil
        }
    )

    viewController.overrideUserInterfaceStyle = .light

    let strategy: Snapshotting<UIViewController, UIImage> = delay > 0
        ? .wait(for: delay, on: .image(on: .iPhone16Pro, precision: precision))
        : .image(on: .iPhone16Pro, precision: precision)

    assertSnapshot(
        of: viewController,
        as: strategy,
        named: named + "light",
        fileID: fileID,
        file: filePath,
        testName: named,
        line: line,
        column: column
    )

    viewController.overrideUserInterfaceStyle = .dark

    assertSnapshot(
        of: viewController,
        as: strategy,
        named: named + "dark",
        fileID: fileID,
        file: filePath,
        testName: named,
        line: line,
        column: column
    )

}
