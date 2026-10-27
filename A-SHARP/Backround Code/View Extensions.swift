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

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .regular)) // Native toolbar icon sizing
            .foregroundStyle(configuration.isPressed ? .secondary : .primary)
            .padding(8)
            .contentShape(Rectangle()) // Ensures the empty space around a small icon is tappable
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Convenience extension for clean dot-notation access
extension ButtonStyle where Self == ToolbarButtonStyle {
    static var toolbarLike: ToolbarButtonStyle { ToolbarButtonStyle() }
}
