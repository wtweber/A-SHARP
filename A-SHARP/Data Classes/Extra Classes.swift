//
//  Extra Classes.swift
//  A-SHARP
//
//  Created by William Weber on 2/1/26.
//

import Foundation
import SwiftData


@Model
class Landing {
    var id: UUID? = UUID()
    var type: LandingType?
    var count: Int = 0
    
    var flight: Flight?
    
    init() { }
    init(type: LandingType, count: Int) {
        self.type = type
        self.count = count
    }
}


@Model
class Approach {
    var type: ApproachType?
    var count: Int = 0
    
    var flight: Flight?
    
    init() {}
    
    init(type: ApproachType, count: Int) {
        self.type = type
        self.count = count
    }
}

@Model
class Import: Equatable {
    var source: ImportSource?
    var date: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \Flight.source) var flights: [Flight]?
    
    init(source: ImportSource) {
        self.source = source
        self.date = Date.now
    }
}

class Record {
    
}
