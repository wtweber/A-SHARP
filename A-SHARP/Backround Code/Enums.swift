//
//  Enums.swift
//  A-SHARP Data Formatter
//
//  Created by William Weber on 1/15/26.
//

import Foundation
import SwiftUI

//MARK: AIRCRAFT DATA ENUMS
enum AircraftType: String, Codable, CaseIterable, Identifiable {
    case Glider = "1"
    case Balloon = "2"
    case Blimp_Dirigible = "3"
    case Fixed_Wing_Single_Engine = "4"
    case Fixed_Wing_Multi_Engine = "5"
    case Rotorcraft = "6"
    case Weight_Shift_Control = "7"
    case Powered_Parachute = "8"
    case Gyroplane = "9"
    case Hybrid_Lift = "H"
    case Other = "O"
    
    
    init?(typeString _c: String) {
        if _c.count != 3 {
            return nil
        }
        let f = _c.first!
        let eIndex = _c.index(_c.startIndex, offsetBy: 1)
        let e = _c[eIndex]

        switch f {
        case "L", "A", "S":
            if e == "1" { self = .Fixed_Wing_Single_Engine}
            else { self = .Fixed_Wing_Multi_Engine }
        case "G": self = .Gyroplane
        case "H": self = .Rotorcraft
        case "T": self = .Hybrid_Lift
        default: return nil
        }
    }
    
    var id: String {
        self.rawValue
    }
    
    var description: String {
        switch self {
        case .Glider: return "Glider"
        case .Balloon: return "Balloon"
        case .Blimp_Dirigible: return "Blimp/Dirigible"
        case .Fixed_Wing_Single_Engine: return "Fixed Wing, Single Engine"
        case .Fixed_Wing_Multi_Engine: return "Fixed Wing, Multi Engine"
        case .Rotorcraft: return "Helocopter"
        case .Weight_Shift_Control: return "Weight Shift Control"
        case .Powered_Parachute: return "Powered Parachute"
        case .Gyroplane: return "Gyroplane"
        case .Hybrid_Lift: return "Tiltrotor/Hybrid Lift"
        case .Other: return "Other"
        }
    }
}

enum EngineType: String, Codable, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case None = "0"
    case Recipercating = "1"
    case TurboProp = "2"
    case TurboShaft = "3"
    case TurboJet = "4"
    case TurboFan = "5"
    case Ramjet = "6"
    case TwoCycle = "7"
    case FourCycle = "8"
    case Unknown = "9"
    case Electric = "10"
    case Rotary = "11"
    
    init?(typeString _c: String) {
        if _c.count != 3 {
            return nil
        }
        let e = _c.last!
        
        switch e {
        case "J": self = .TurboJet
        case "T": self = .TurboProp
        case "P": self = .FourCycle
        case "E": self = .Electric
        case "R": self = .Ramjet
        default: self = .None
        }
    }
    
    var description: String {
        switch self {
        case .None: return "Engines"
        case .Recipercating: return "Recipercating Engine"
        case .TurboProp: return "Turbo Prop Engine"
        case .TurboShaft: return "Turbo Shaft Engine"
        case .TurboJet: return "Turbo Jet Engine"
        case .TurboFan: return "Turbo Fan Engine"
        case .Ramjet: return "Ramjet Engine"
        case .TwoCycle: return "Two Cycle Engine"
        case .FourCycle: return "Four Cycle Engine"
        case .Unknown: return "Unknown Engine"
        case .Electric: return "Electric Engine"
        case .Rotary: return "Rotary Engine"
        }
    }
}

enum AircraftCatagory: String, Codable, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case Land = "1"
    case Sea = "2"
    case Amphibian = "3"
    
    init?(typeString _c: String) {
        if _c.count != 3 {
            return nil
        }
        let f = _c.first!
        
        switch f {
        case "S": self = .Sea
        case "A": self = .Amphibian
        default: self = .Land
        }
        
    }
    var description: String {
        switch self {
        case .Land: return "Land"
        case .Amphibian: return "Amphibian"
        case .Sea: return "Sea"
        }
    }
}

enum AirportType: String, Codable, CaseIterable, Identifiable {
    
    case balloonport, closed_airport, heliport, large_airport, medium_airport, seaplane_base, small_airport
    
    var id: Self { self }
    
    var description: String {
        return rawValue.replacingOccurrences(of: "_", with: " ")
    }
    
    var annotationImage: Image {
        switch self {
        case .large_airport: return Image("airport.large")
        case .medium_airport: return Image("airport.medium")
        case .small_airport: return Image("airport.small")
        case .closed_airport: return Image("airport.closed")
        case .seaplane_base: return Image("airport.seaplane")
        case .balloonport: return Image("airport.balloon")
        case .heliport: return Image("airport.heliport")
        }
    }
    
    
}

enum identType: String {
    case icao
    case iata
    case registration
    case serialNumber
    case faa
    
    var name: String {
        return self.rawValue
    }
}

enum PilotTimeType: String {
    case pic, sic, night, dualRecieved, instructor, solo, crossCountry, specialCrew
}

enum FlightConditions: String {
    case night, actualInstrument, simulatedInstrument
}

enum CompanyColor: String {
    case UAL, SWA, AAL, DAL, FFT, ASA, NKS, NAVY, USMC, AAF
    
    var color: Color {
        switch self {
        case .UAL: Color.UAL
        case .SWA: Color.SWA
        case .AAL: Color.AAL
        case .DAL: Color.DAL
        case .FFT: Color.FFT
        case .ASA: Color.ASA
        case .NKS: Color.NKS
        case .NAVY: Color.NAVY
        case .USMC: Color.USMC
        default: Color.accent
        }
    }
}

enum ApproachType: String, Codable, CaseIterable, Identifiable {
    case Percision_Simulated = "A"
    case Nonpercision_Simulated = "B"
    case Percision_Actual = "1"
    case Nonpercision_Actual = "2"
    case Auto_Actual = "3"
    case Auto_Simulated = "C"
    case AutoNVD_Actual = "4"
    case DegradedVis_Actual = "5"
    case DegradedVis_Simulated = "E"
    case UAS_Simulated = "F"
    
    case ILS = "I"
    case VOR = "V"
    case RNAV = "R"
    case Visual = "Z"
    
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .Percision_Simulated: return "Percision Simulated"
        case .Nonpercision_Simulated: return "Nonpercision Simulated"
        case .Percision_Actual: return "Percision Actual"
        case .Nonpercision_Actual: return "Nonpercision Actual"
        case .Auto_Actual: return "Auto Actual"
        case .Auto_Simulated: return "Auto Simulated"
        case .AutoNVD_Actual: return "Auto NVD Actual"
        case .DegradedVis_Actual: return "Degraded Vis Actual"
        case .DegradedVis_Simulated: return "Degraded Vis Simulated"
        case .UAS_Simulated: return "UAS Simulated"
        case .ILS: return "ILS"
        case .VOR: return "VOR"
        case .RNAV: return "RNAV"
        case .Visual: return "Visual"
        }
    }
    
    static let military: [ApproachType] = [.Percision_Simulated, .Nonpercision_Simulated, .Percision_Actual, .Nonpercision_Actual, .Auto_Actual, .Auto_Simulated, .AutoNVD_Actual, .DegradedVis_Actual, .DegradedVis_Simulated, .UAS_Simulated]
    static let civilian: [ApproachType] = [.ILS, .VOR, .RNAV, .Visual]
}

enum LandingType: String, Codable, CaseIterable, Identifiable {
    case FieldFullStop_Day = "6"
    case FieldFullStop_Night = "F"
    case FieldTG_Day = "W"
    case FieldTG_Night = "T"
    case FieldArrest_Day = "7"
    case FieldArrest_Night = "G"
    
    case Unprepared_Day = "L"
    case Unprepared_Night = "M"
    
    case ShipArrest_Day = "1"
    case ShipArrest_Night = "A"
    case ShipTG_Day = "2"
    case ShipTG_Night = "B"
    case ShipBolter_Day = "3"
    case ShipBolter_Night = "C"
    case ShipHelo_Day = "4"
    case ShipHelo_Night = "D"
    case ShipUAS_Night = "I"
    
    case FCLP_Day = "5"
    case FCLP_Night = "E"
    
    case FixedNozzleSlow_Day = "8"
    case FixedNozzleSlow_Night = "H"
    case FieldVert_Day = "9"
    case FieldVert_Night = "J"
    case VertRoll_Day = "0"
    case VertRoll_Night = "K"
    
    case FieldUAS_Night = "U"
    case NVDShip_Night = "N"
    case NVDField_Night = "P"
    case NVDFDLP_Night = "Q"

    case NFO_Day = "Y"
    case NFO_Night = "Z"
    case ReducedVis_Day = "R"
    case ReducedVis_Night = "S"
    
    var name: String {
        switch self {
        case .ShipArrest_Day: return "Ship Arrest Day"
        case .ShipArrest_Night: return "Ship Arrest Night"
        case .ShipTG_Day: return "Ship Touch & Go Day"
        case .ShipTG_Night: return "Ship Touch & Go Night"
        case .ShipBolter_Day: return "Ship Bolter Day"
        case .ShipBolter_Night: return "Ship Bolter Night"
        case .ShipHelo_Day: return "Ship Helo Day"
        case .ShipHelo_Night: return "Ship Helo Night"
        case .FCLP_Day: return "FCLP Day"
        case .FCLP_Night: return "FCLP Night"
        case .FieldFullStop_Day: return "Full Stop Day"
        case .FieldFullStop_Night: return "Full Stop Night"
        case .FieldArrest_Day: return "Arrest Day"
        case .FieldArrest_Night: return "Arrest Night"
        case .FixedNozzleSlow_Day: return "Fixed Nozzle Slow Day"
        case .FixedNozzleSlow_Night: return "Fixed Nozzle Slow Night"
        case .FieldVert_Day: return "Vertical Day"
        case .FieldVert_Night: return "Vertical Night"
        case .VertRoll_Day: return "Vertical Roll Day"
        case .VertRoll_Night: return "Vertical Roll Night"
        case .FieldTG_Day: return "Touch & Go Day"
        case .FieldTG_Night: return "Touch & Go Night"
        case .ShipUAS_Night: return "Ship UAS Night"
        case .FieldUAS_Night: return "UAS Night"
        case .NVDShip_Night: return "NVD Ship Night"
        case .NVDField_Night: return "NVD Field Night"
        case .NVDFDLP_Night: return "NVD FCLP Night"
        case .Unprepared_Day: return "Unprepared Surface Day"
        case .Unprepared_Night: return "Unprepared Surface Night"
        case .NFO_Day: return "NFO Day"
        case .NFO_Night: return "NFO Night"
        case .ReducedVis_Day: return "Reduced Visibility Day"
        case .ReducedVis_Night: return "Reduced Visibility Night"
        }
    }
    
    var id: Self { self }
    
    var isDay: Bool {
        switch self {
        case .ShipArrest_Day, .ShipTG_Day, .ShipBolter_Day, .ShipHelo_Day, .FCLP_Day,
                .FieldFullStop_Day, .FieldArrest_Day, .FixedNozzleSlow_Day, .FieldVert_Day,
                .VertRoll_Day, .FieldTG_Day, .Unprepared_Day, .NFO_Day, .ReducedVis_Day: return true
        default: return false
        }
    }
    
    static let military: [LandingType] = [ .FieldFullStop_Day, .FieldFullStop_Night, .FieldTG_Day, .FieldTG_Night, .ShipArrest_Day, .ShipArrest_Night, .ShipTG_Day, .ShipTG_Night, .ShipBolter_Day, .ShipBolter_Night, .ShipHelo_Day, .ShipHelo_Night, .FCLP_Day, .FCLP_Night, .FieldArrest_Day, .FieldArrest_Night, .FixedNozzleSlow_Day, .FixedNozzleSlow_Night, .FieldVert_Day, .FieldVert_Night, .VertRoll_Day, .VertRoll_Night, .ShipUAS_Night, .FieldUAS_Night, .NVDShip_Night, .NVDField_Night, .NVDFDLP_Night, .Unprepared_Day, .Unprepared_Night, .NFO_Day, .NFO_Night, .ReducedVis_Day, .ReducedVis_Night]
    
    static let civilian: [LandingType] = [.FieldFullStop_Day, .FieldFullStop_Night, .FieldTG_Day, .FieldTG_Night]
}

enum FlightType: String, Codable {
    case generalAviation, airline, military, unknown
    
    var name: String {
        switch self {
        case .generalAviation: "General Aviation"
        case .airline: "Airlines"
        case .military: "Military"
        default: "Unknown"
        }
    }
    
    var nonFlyingName: String {
        switch self {
        case .airline: "Dead Head"
        case .military: "Special Crew"
        default: "Passenger"
        }
    }
    
    var color: Color {
        switch self {
        case .generalAviation: .orange
        case .airline: .blue
        case .military: .green
        default: .yellow
        }
    }
    
    var operatorName: String {
        switch self {
        case .airline: "Company Code"
        case .military: "Unit Code"
        default: ""
        }
    }
    var operatorExample: String {
        switch self {
        case .airline: "eg: UAL or SWA"
        case .military: "eg: MNTNA or SUMO"
        default: ""
        }
    }
    var civilian: Bool {
        switch self {
        case .airline, .generalAviation: true
        default: false
        }
    }
    var military: Bool {
        switch self {
        case .military: true
        default: false
        }
    }
}

enum AltChange: String, Codable {
    case C, D, N
}

enum UpdateType: String, Codable {
    case P, O, Z, A, M, D, X, S, V
}

/*enum Role: String, Codable {
    case pic, sic, ins, std, obs
}*/

enum AirportCodeType: String {
    case icao, iata, localCode, gpsCode
}

enum ImportSource: String, CaseIterable, Identifiable, Codable {
    case ccsPlus, SHARP, MSHARP, manual, bruteForce, flightAware, ASHARP
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .ccsPlus: return "CCS+"
        case .SHARP: return "SHARP"
        case .MSHARP: return "M-SHARP"
        case .manual: return "Manual Import"
        case .bruteForce: return "Brute Force"
        case .flightAware: return "FlightAware"
        case .ASHARP: return "A-SHARP"
        }
    }
    
    var fileImport: Bool {
        switch self {
        case .ASHARP, .MSHARP, .SHARP, .ccsPlus, .manual: return true
        default: return false
        }
    }
}

enum FileImportError: Error {
    case xlsxIsCorrupt
    case fileIsNotXLSX
    case fileFormatError
    case noFileAccess
    case csvIsCorrupt
    case unknown

}
extension FileImportError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .xlsxIsCorrupt, .csvIsCorrupt:
            return NSLocalizedString("File is corrupt", comment: "Corrupt file error")
        case .fileIsNotXLSX:
            return NSLocalizedString("File is not an XLSX file", comment: "File type error")
        case .fileFormatError:
            return NSLocalizedString("File layout unexpected", comment: "Layout error")
        case .noFileAccess:
            return NSLocalizedString("Unable to access file", comment: "Access error")
        default:
            return NSLocalizedString("An unknown error has occured", comment: "Unknown error")
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .xlsxIsCorrupt:
            return NSLocalizedString("Please try to save the file again using Excel.  If that is unsucessfull try exporting the logbook as a CSV and do a manual import.", comment: "Recovery suggestion for corrupt file.")
        case .csvIsCorrupt:
            return NSLocalizedString("Please try to save the file again ensuring it's plain text and has no encryption or password.", comment: "Recovery suggestion for corrupt file.")
        case .fileIsNotXLSX:
            return NSLocalizedString("The import source selected expects an XLSX file.  Check the file selected and try again.", comment: "Recovery suggestion for file type.")
        case .fileFormatError:
            return NSLocalizedString("The import ran into an error processing all the data.  Please check the file layout and try again", comment: "Recovery suggestion for file layout.")
        case .noFileAccess:
            return NSLocalizedString("Unable to open the file. Please check the file permissions and try again.", comment: "Recovery suggestion for file access")
        default:
            return NSLocalizedString("This app is perfect, so you just need to fix whatever you did wrong.", comment: "Fix yourself")
        }
    }
}


enum UnitedTypes: String {
    case B737 = "73G"
    case B738 = "738"//"73Y"
    case B738Guam = "73U"
    case B738SP = "73Q"
    case B739 = "73C"
    case B739ER = "739"//"37K"
    case B38M = "37E"
    case B39M = "37X"
    case B752B = "75B"
    case B752S = "75S"
    case B753 = "75E"
    case B763Pol = "76L"
    case B763 = "76Q"
    case B764 = "76U"
    case B772G = "77G"
    case B772M = "77M"
    case B772O = "77O"
    case B722N = "77N"
    case B722U = "77U"
    case B772E = "77E"
    case B77W = "77X"
    case B788 = "78H"
    case B789P = "78P"
    case B789L = "78L"
    case B78X = "78J"
    case A319F = "19F"
    case A319G = "19G"
    case A320C = "20C"
    case A320S = "20S"
    case A21N = "21N"
    
    
    
    var icaoType: String {
        switch self {
        case .B737: return "B737"
        case .B738, .B738SP, .B738Guam: return "B738"
        case .B739, .B739ER: return "B739"
        case .B38M: return "B38M"
        case .B39M: return "B39M"
        case .B752B, .B752S: return "B752"
        case .B753: return "B753"
        case .B763, .B763Pol: return "B763"
        case .B764: return "B764"
        case .B772G, .B772M, .B772O, .B722N, .B722U, .B772E: return "B772"
        case .B77W: return "B77W"
        case .B788: return "B788"
        case .B789P, .B789L: return "B789"
        case .B78X: return "B78X"
        case .A319F, .A319G: return "A319"
        case .A320C, .A320S: return "A320"
        case .A21N: return "A21N"
        }
    }

    var manufacturer: String {
        switch self {
        case .B737, .B738, .B738SP, .B738Guam, .B739, .B739ER, .B38M, .B39M: return "Boeing"
        case .B752B, .B752S, .B753, .B763Pol, .B763, .B764: return "Boeing"
        case .B772G, .B772M, .B772O, .B722N, .B722U, .B772E, .B77W: return "Boeing"
        case .B788, .B789P, .B789L, .B78X: return "Boeing"
        case .A319F, .A319G, .A320C, .A320S, .A21N: return "Airbus"
        }
    }
    var model: String {
        switch self {
        case .B737: return "737-700"
        case .B738: return "737-800"
        case .B738SP: return "737-800 Short Field Performance"
        case .B738Guam: return "B738 Micronesia"
        case .B739: return "737-900"
        case .B739ER: return "737-900ER"
        case .B38M: return "737-MAX8"
        case .B39M: return "737-MAX9"
        case .B752B, .B752S: return "757-200"
        case .B753: return "757-300"
        case .B763, .B763Pol: return "767-300 ER"
        case .B764: return "767-400"
        case .B772G, .B772M, .B772O, .B722N, .B722U, .B772E: return "777-200"
        case .B77W: return "777-300ER"
        case .B788: return "787-8"
        case .B789P, .B789L: return "787-9"
        case .B78X: return "787-10"
        case .A319F, .A319G: return "A319"
        case .A320C, .A320S: return "A320"
        case .A21N: return "A321 Neo"
        }
    }
    
    static let aircraftType: AircraftType = .Fixed_Wing_Multi_Engine
    static let engineType: EngineType = .TurboFan
    static let aircraftCatagory: AircraftCatagory = .Land

    var engineManufacturer: String {
        switch self {
        case .B737, .B738, .B738SP, .B738Guam, .B739, .B739ER, .B38M, .B39M: return "CFM International"
        case .B752B, .B752S, .B753: return "Rolls-Royce"
        case .B763, .B763Pol: return "Pratt & Whitney"
        case .B764: return "General Electric"
        case .B772G, .B772M, .B772O, .B722N, .B722U: return "Pratt & Whitney"
        case .B77W, .B772E: return "General Electric"
        case .B788, .B789P, .B789L, .B78X: return "General Electric"
        case .A319F, .A319G, .A320C, .A320S: return "International Aero Engines"
        case .A21N: return "Pratt & Whitney"
        }
        
    }
    var engineModel: String {
        switch self {
        case .B737, .B738, .B738SP, .B738Guam, .B739, .B739ER: return "CFM56-7"
        case .B38M, .B39M: return "LEAP-1B"
        case .B752B, .B752S, .B753: return "RB211"
        case .B763, .B763Pol: return "PW4060"
        case .B764: return "CF6-80"
        case .B772G, .B772M: return "PW4700"
        case .B772O, .B722N, .B722U: return "PW4090"
        case .B77W: return "GE90-94B"
        case .B772E: return "GE90-115BL"
        case .B788: return "GEnx-1B70/P2"
        case .B789P, .B789L: return "GEnx-1B76A"
        case .B78X: return "GEnx-1B76"
        case .A319F: return "V2522-A5"
        case .A319G: return "V2524-A5"
        case .A320C, .A320S: return "V2527-A5"
        case .A21N: return "PW1133G-JM"
        }
    }
    
    var engineCount: Int {
        switch self {
        default: return 2
        }
    }
    
    var engineThrust: Int {
        switch self {
        case .B737: return 24000
        case .B738, .B738Guam, .B739: return 26000
        case .B738SP, .B739ER: return 27000
        case .B38M, .B39M: return 28000
        case .B752B, .B752S, .B753: return 42700
        case .B763, .B763Pol: return 60000
        case .B764: return 63500
        case .B772G, .B772M: return 79900
        case .B772O, .B722N, .B722U: return 91700
        case .B77W: return 94000
        case .B772E: return 115500
        case .B788: return 69800
        case .B789P, .B789L: return 76100
        case .B78X: return 76100
        case .A319F: return 22000
        case .A319G: return 24000
        case .A320C, .A320S: return 26500
        case .A21N: return 33100
        }
    }
    
    var aircraft: Aircraft {
        return Aircraft(manufacturer: self.manufacturer, model: self.model, aircraftType: .Fixed_Wing_Multi_Engine, engineType: .TurboFan, aircraftCatagory: .Land, engineManufacturer: self.engineManufacturer, engineModel: self.engineModel, engineCount: 2, engineThrust: self.engineThrust, icaoCode: self.icaoType, faaCode: self.icaoType)
    }
}


enum SHARPType: String {
    case KC30J = "KC-130J"
    case C30J = "C-130J"
    case T44C = "T-44C"
    case T34T = "T-34C"
    
    var icaoCode: String? {
        switch self {
        case .KC30J, .C30J: return "C30J"
        case .T44C: return "BE9L"
        case .T34T: return "T34T"
        }
    }

    var manufacturer: String? {
        switch self {
        case .KC30J, .C30J:return "Lockheed Martin"
        case .T44C, .T34T: return "Beechcraft"
        }
    }
    var model: String? {
        switch self {
        case .KC30J: return "KC-130J Super Hercules"
        case .C30J:return "C-130J Super Hercules"
        case .T44C: return "T-44C Pegasus"
        case .T34T: return "T-34C Turbo Mentor"
        }
    }
    
    var aircraftType: AircraftType? {
        switch self {
        case .C30J, .KC30J, .T44C: return .Fixed_Wing_Multi_Engine
        case .T34T: return .Fixed_Wing_Single_Engine
        }
    }
    var engineType: EngineType? {
        switch self {
        case .C30J, .KC30J, .T44C, .T34T: return .TurboProp
        }
    }

    var engineManufacturer: String? {
        switch self {
        case .C30J, .KC30J: return "Rolls-Royce"
        case .T44C, .T34T: return "Pratt & Whitney"
        }
    }
    var engineModel: String? {
        switch self {
        case .C30J, .KC30J: return "AE 2100"
        case .T44C, .T34T: return "PT6A"
        }
    }
    
    var engineCount: Int? {
        switch self {
        case .C30J, .KC30J: return 4
        case .T44C: return 2
        case .T34T: return 1
        }
    }
    
    var engineThrust: Int? {
        switch self {
        case .C30J, .KC30J: return nil
        case .T44C: return nil
        default: return nil
        }
    }
    
    var aircraft: Aircraft {
        return Aircraft(manufacturer: self.manufacturer, model: self.model,
                        aircraftType: self.aircraftType, engineType: self.engineType,
                        aircraftCatagory: .Land,
                        engineManufacturer: self.engineManufacturer, engineModel: self.engineModel,
                        engineCount: self.engineCount, engineThrust: self.engineThrust,
                        icaoCode: self.icaoCode, faaCode: self.icaoCode)
    }
}

