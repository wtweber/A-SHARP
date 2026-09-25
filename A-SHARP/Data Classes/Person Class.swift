//
//  Person Class.swift
//  A-SHARP
//
//  Created by William Weber on 2/15/26.
//

import Foundation
import SwiftData

@Model
class Person {
    var id: String?
    var firstName: String?
    var lastName: String?
    
    var flights: [Flight]?
    
    init() {
    }
    
    init(id: String? = nil, firstName: String? = nil, lastName: String? = nil) {
        self.id = id
        self.firstName = firstName?.capitalized
        self.lastName = lastName?.capitalized
    }
    
    var firstLetter: String? {
        if let char = lastName?.first {
            return String(char)
        }
        return nil
    }
    
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
}
