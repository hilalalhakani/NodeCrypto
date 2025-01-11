//
//  keyboard.swift
//  Main
//
//  Created by Hilal Hakkani on 06/01/2025.
//

import SwiftUI
import Combine

#if os(iOS)
    struct KeyboardAwareModifier: ViewModifier {
        @State private var keyboardHeight: CGFloat = 0

        var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
            Publishers
                .Merge(
                    NotificationCenter
                        .default
                        .publisher(for: UIResponder.keyboardWillShowNotification)
                        .compactMap {
                            $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                        }
                        .map { $0.cgRectValue.height },
                    NotificationCenter
                        .default
                        .publisher(for: UIResponder.keyboardWillHideNotification)
                        .map { _ in 0 }
                )
                .eraseToAnyPublisher()
        }
        func body(content: Content) -> some View {
            content
                .padding(.bottom, keyboardHeight)
                .onReceive(keyboardHeightPublisher) { height in
                    withAnimation { self.keyboardHeight = height }
                }
        }
    }

    extension View {
        func adaptsKeyboard() -> some View {
            self.modifier(KeyboardAwareModifier())
        }
    }
#endif
