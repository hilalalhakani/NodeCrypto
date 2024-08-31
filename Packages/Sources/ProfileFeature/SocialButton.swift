//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 09/04/2024.
//

import Foundation
import SwiftUI

struct SocialButton: View {
    let action: () -> Void
    let imageResource: ImageResource
    var body: some View {
        Button(
            action: action,
            label: {
                Circle()
                    .foregroundColor(Color.neutral6)
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image(imageResource)
                            .resizable()
                            .foregroundStyle(Color.neutral2)
                            .frame(width: 16, height: 16)
                    }
            }
        )
    }
}
