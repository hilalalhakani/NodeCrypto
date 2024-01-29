//
//  File.swift
//  
//
//  Created by HH on 30/12/2023.
//

import Foundation
import SwiftUI
import StyleGuide

struct LabelsView: View {
  var message1: AttributedString {
    var result = AttributedString(
      String(localized: "By connecting your wallet, you agree to our", bundle: .module))
    result.font = Font(FontName.poppinsRegular, size: 12)
    result.foregroundColor =   Color.neutral4
    return result
  }

  var message2: AttributedString {
    var result = AttributedString(String(localized: "Terms of Service", bundle: .module))
    result.link = URL(string: "https://stackoverflow.com")
    result.font = Font(FontName.poppinsRegular, size: 12)
      result.foregroundColor = Color.neutral3
    return result
  }

  var message3: AttributedString {
    var result = AttributedString(String(localized: "and our", bundle: .module))
    result.font = Font(FontName.poppinsRegular, size: 12)
      result.foregroundColor =  Color.neutral4
    return result
  }

  var message4: AttributedString {
    var result = AttributedString(String(localized: "Privacy and Policy", bundle: .module))
    result.link = URL(string: "https://google.com")
    result.font = Font(FontName.poppinsRegular, size: 12)
      result.foregroundColor = Color.neutral3
    return result
  }

  var body: some View {
    Text(message1 + " " + message2 + " " + message3 + " " + message4)
  }
}
