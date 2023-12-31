//
//  File.swift
//  
//
//  Created by HH on 30/12/2023.
//

import Foundation
import SwiftUI

struct BackgroundLinearGradient: View {
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    LinearGradient(
      stops: colorScheme == .light
        ? [
          Gradient.Stop(color: Color.hex(0xA4A8FF), location: 0.50),
          Gradient.Stop(color: Color.hex(0xFFA4E0), location: 1.00),
        ]
        : [
            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.09), location: 0.00),
            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.09).opacity(0.7), location: 1.00),
        ],
      startPoint: UnitPoint(x: 1, y: 0),
      endPoint: UnitPoint(x: 0, y: 1)
    )
    .ignoresSafeArea()
  }
}
