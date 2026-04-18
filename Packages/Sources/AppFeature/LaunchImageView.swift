//
//  SwiftUIView.swift
//
//
//  Created by HH on 10/12/2023.
//

import SwiftUI

struct LaunchImageView: View {
    var body: some View {
        Image("SplashScreen", bundle: .module)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .transition(.opacity.animation(.easeInOut))
    }
}

#Preview {
    LaunchImageView()
}
