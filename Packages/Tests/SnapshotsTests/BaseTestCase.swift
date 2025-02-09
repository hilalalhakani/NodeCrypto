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
    try #require(UIDevice.modelName == "iPhone 15")
    UIView.setAnimationsEnabled(false)
    let viewController = UIHostingController(
        rootView: view.transaction{
            $0.disablesAnimations = true
            $0.animation = nil
        }
    )

    viewController.overrideUserInterfaceStyle = .light

    assertSnapshot(
        of: viewController,
        as: .wait(for: delay, on: .image(on: .iPhone15, precision: precision)),
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
        as: .wait(for: delay, on: .image(on: .iPhone15, precision: precision)),
        named: named + "dark",
        fileID: fileID,
        file: filePath,
        testName: named,
        line: line,
        column: column
    )

}
