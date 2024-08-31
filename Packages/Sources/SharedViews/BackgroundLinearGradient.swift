//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 06/06/2024.
//

import Foundation
import SwiftUI

public struct BackgroundLinearGradient: View {
  var colors: [Color]

    public init(colors: [Color]) {
        self.colors = colors
    }

    public var body: some View {
    LinearGradient(
      stops: [Gradient.Stop(color: colors[0], location: 0.50), Gradient.Stop(color: colors[1], location: 1.00)],
      startPoint: UnitPoint(x: 1, y: 0),
      endPoint: UnitPoint(x: 0, y: 1)
    )
  }
}
