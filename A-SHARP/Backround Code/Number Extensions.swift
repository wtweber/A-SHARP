//
//  Number Extensions.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import Foundation

extension Numeric {
    func nonZeroString(decimals: Int = 0, leadSpaces: Int = 0) -> String {
        //let value = Double(self)
        let nonZeroInt = NumberFormatter()
        nonZeroInt.zeroSymbol = ""
        nonZeroInt.usesGroupingSeparator = true
        nonZeroInt.groupingSeparator = ","
        nonZeroInt.maximumFractionDigits = decimals
        
        return String(repeating: " ", count: leadSpaces) + (nonZeroInt.string(from: self as? NSNumber ?? NSNumber(value: 0)) ?? "")
    }
}

extension Double {
    var hourClock: String? {
        let timeInt: TimeInterval = self * 3600
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInt)
    }

}
