//
//  File.swift
//  
//
//  Created by HH on 30/12/2023.
//

import Foundation
import SwiftUI

struct BackgroundLinearGradient: View {
  var body: some View {
    LinearGradient(
        stops: [
            Gradient.Stop(color: .connectWalletGradient1, location: 0.50),
            Gradient.Stop(color: .connectWalletGradient2, location: 1)
        ],
      startPoint: UnitPoint(x: 1, y: 0),
      endPoint: UnitPoint(x: 0, y: 1)
    )
    .ignoresSafeArea()
  }
}
