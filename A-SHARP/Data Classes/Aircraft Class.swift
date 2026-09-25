//
//  Aircraft Class.swift
//  A-SHARP
//
//  Created by William Weber on 1/26/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Aircraft {
    var registration: String?
    var serialNumber: String?
    
    var manufacturer: String?
    var model: String?
    var year: Int?
    
    var aircraftType: AircraftType?
    var engineType: EngineType?
    var aircraftCatagory: AircraftCatagory?
    
    var engineManufacturer: String?
    var engineModel: String?
    var engineCount: Int?
    var engineThrust: Int?
    var enginePower: Int?
    //var engineType: EngineType?
    
    var modeS: String?
    
    var icaoCode: String?
    var faaCode: String?
    
    var flights: [Flight]?
    
    @Attribute(.externalStorage) var imageData: Data?
    var imageLink: URL?
    var photographer: String?
    
    var image: Image? {
        if let imageData = imageData as Data? {
            if let ui = UIImage(data: imageData) {
                return Image(uiImage: ui)
            } else { return nil }
            
        }
        return nil
    }
    
    init() { }
    
    init(registration: String? = nil, serialNumber: String? = nil, manufacturer: String? = nil, model: String? = nil, year: Int? = nil, aircraftType: AircraftType? = nil, engineType: EngineType? = nil, aircraftCatagory: AircraftCatagory? = nil, engineManufacturer: String? = nil, engineModel: String? = nil, engineCount: Int? = nil, engineThrust: Int? = nil, enginePower: Int? = nil, modeS: String? = nil, icaoCode: String?, faaCode: String?) {
        self.registration = registration
        self.serialNumber = serialNumber
        self.manufacturer = manufacturer
        self.model = model
        self.year = year
        self.aircraftType = aircraftType
        self.engineType = engineType
        self.aircraftCatagory = aircraftCatagory
        self.engineManufacturer = engineManufacturer
        self.engineModel = engineModel
        self.engineCount = engineCount
        self.engineThrust = engineThrust
        self.enginePower = enginePower
        self.modeS = modeS
        self.icaoCode = icaoCode
        self.faaCode = faaCode
    }
    
    init(icao: String?) {
        self.icaoCode = icao
    }
    
    var description: String {
        return "N\(registration ?? "?")/\(serialNumber ?? "?") \(manufacturer ?? "") \(model ?? "unknown model") powered by \(engineCount ?? 0) \(engineManufacturer ?? "")/\(engineModel ?? "unknown model") engine."
    }
    
    
}

extension Aircraft {
    var engineString: String? {
        if let engineCount, let engineManufacturer, let engineModel {
            return "\(engineCount) \(engineManufacturer) \(engineModel)"
        }
        if let engineCount, let engineType {
            return "\(engineCount) \(engineType.description)\(engineCount > 1 ? "s" : "")"
        }
        return nil
    }
}

extension Aircraft {
    var totalFlightTime: Double {
        return flights?.map { $0.totalTime ?? 0.0 }.reduce(0.0, +) ?? 0.0
    }
    
    var lastFlown: Date? {
        let lastFlight = self.flights?.sorted { $0.date > $1.date }.first
        return lastFlight?.date
    }
}
