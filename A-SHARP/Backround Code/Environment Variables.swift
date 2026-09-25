//
//  Environment Variables.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import Foundation
import SwiftUI

private struct WindowSizeKey: EnvironmentKey {
    // A default fallback value
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var windowSize: CGSize {
        get { self[WindowSizeKey.self] }
        set { self[WindowSizeKey.self] = newValue }
    }
}
