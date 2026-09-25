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
