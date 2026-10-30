//
//  Date Extensions.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import Foundation

extension Date {
    var timestamp: String {
        Date.now.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)))
    }
    
    var dateStamap: String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.gmt
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
    
    func formatedTimeString(timeZone: TimeZone? = TimeZone.gmt) -> String {
        let formatter = DateFormatter()

        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone ?? TimeZone.gmt
        
        if formatter.timeZone == TimeZone.gmt {
            formatter.dateFormat = "HH:mm'Z'"
        } else {
            formatter.dateFormat = "HH:mm'L'"
        }
        return formatter.string(from: self)
    }
}

extension TimeZone {
    var gmtString: String {
        let formatter = DateFormatter()
        formatter.timeZone = self
        formatter.dateFormat = "ZZZZZ"

        return "GMT\(formatter.string(from: Date()))"
    }
}

extension Duration {
    var days: Double {
        return Double(self.components.seconds) / 86400.0
    }
    var weeks: Double {
        Double(self.components.seconds) / 604800.0
    }
    var months: Double {
        Double(self.components.seconds) / 2628000.0
    }
    var years: Double {
        Double(self.components.seconds) / 31536000.0
    }
    
    func divided(by: Int) -> Duration {
        if by == 0 { return self }
        let seconds = self.components.seconds
        return .seconds(Int(seconds) / by)
    }
}

