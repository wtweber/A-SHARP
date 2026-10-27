//
//  View Extensions.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import Foundation
import SwiftUI

extension Color {
    static let viewBackground = Color("OverlayBackground")
}

struct ClearButtonModifier: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .trailing) {
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 8)
                    // Prevents the button from grabbing keyboard focus on macOS/tvOS
                    .buttonStyle(.plain)
                }
            }
    }
}

// 2. Create a View Extension for elegant dot-syntax chaining
extension View {
    func clearButton(text: Binding<String>) -> some View {
        self.modifier(ClearButtonModifier(text: text))
    }
}
