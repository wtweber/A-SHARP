//
//  Flight Class.swift
//  A-SHARP
//
//  Created by William Weber on 1/26/26.
//

import Foundation
import SwiftData
import MapKit
import SwiftUI
import Combine

@Model
class Flight: Decodable, Identifiable {
    
    //MARK: Flight Aweare Data
    var ident: String?  //Either the operator code followed by the flight number for the flight (for commercial flights) or the aircraft's registration (for general aviation).
    var faFlightId: String?  //Unique identifier assigned by FlightAware for this specific flight. If the flight is diverted, the new leg of the flight will have a duplicate fa_flight_id.
    
    var operatorString: String?  //ICAO code, if exists, of the operator of the flight, otherwise the IATA code
    var flightNumber: String?  //Bare flight number of the flight.
    
    //Filed Flight Data
    var filedEte: Int? //Runway-to-runway filed duration (seconds).
    var routeDistance: Int?  //Planned flight distance (statute miles) based on the filed route. May vary from actual flown distance.
    var filedAirspeed: Int?  //Filed IFR airspeed (knots).
    var filedAltitude: Int?  //Filed IFR altitude (100s of feet).
    var route: String?  //The textual description of the flight's route.
    
    //Gates and Baggage claim
    var gateOrigin: String?  //Departure gate at the origin airport.
    var gateDestination: String?  //Arrival gate at the destination airport.
    var actualRunwayOff: String?
    var actualRunwayOn: String?

    //Times
    var scheduledOut: Date?  //Scheduled gate departure time.
    var estimatedOut: Date?  //Estimated gate departure time.
    var actualOut: Date?  //Actual gate departure time.
    var scheduledOff: Date?  //Scheduled runway departure time.
    var estimatedOff: Date?  //Estimated runway departure time.
    var actualOff: Date?  //Actual runway departure time.
    var scheduledOn: Date?  //Scheduled runway arrival time.
    var estimatedOn: Date?  //Estimated runway arrival time.
    var actualOn: Date?  //Actual runway arrival time.
    var scheduledIn: Date?  //Scheduled gate arrival time.
    var estimatedIn: Date?  //Estimated gate arrival time.
    var actualIn: Date?  //Actual gate arrival time.
    
    //Actual Flight Data
    var actualDistance: Int?  //Distance (in miles) flown as of the latest position point. Will include distance from the origin airport to the first position point.
    var actualRoute: [Position]?
    
    //MARK: Flight record data
    var totalTime: Double?
    
    //Flight time type
    var pic: Double?
    var sic: Double?
    var dualGiven: Double?
    var dualRecieved: Double?
    var specialCrew: Double?
    var solo: Double?
    var crossCountry: Double?
    
    //Flight Conditions
    var night: Double?
    var acutalInstrument: Double?
    var simulatedInstrument: Double?
    
    var flightType: FlightType?
    var sorties: Int?
    
    var passengers: Int?
    var cargo: Int?
    var combat: Double?
    var nvg: Double?
    
    var training: [String]?
    var remarks: String?
    
    
    //MARK: Relationships
    @Relationship(deleteRule: .nullify, inverse: \Airport.departures) var origin: Airport?
    @Relationship(deleteRule: .nullify, inverse: \Airport.arrivals) var destination: Airport?
    @Relationship(deleteRule: .nullify, inverse: \Aircraft.flights) var aircraft: Aircraft?
    @Relationship(deleteRule: .cascade, inverse: \Landing.flight) var landings: [Landing]?
    @Relationship(deleteRule: .cascade, inverse: \Approach.flight) var approaches: [Approach]?
    @Relationship(deleteRule: .nullify, inverse: \Person.flights) var crew: [Person]?
    
    var source: Import?
    
    //MARK: Calculated variables
    var routeLine: [CLLocationCoordinate2D]? {
        if let actualRoute {
            return actualRoute.compactMap { $0.coordinate }
        }
        return simpleRoute
    }
    
    var simpleRoute: [CLLocationCoordinate2D]? {
        if let oLoc = origin?.location, let dLoc = destination?.location {
            return [oLoc, dLoc]
        }
        return nil
    }
    
    var date: Date {
        if let scheduledOut { return scheduledOut }
        else if let actualOut { return actualOut }
        else if let actualOff { return actualOff }
        return Date()
    }
    
    var groupDate: String {
        return self.date.formatted(.dateTime.year().month())
        //let calendar = Calendar.current
        //let components = calendar.dateComponents([.year, .month], from: date)
        //let calendar.date(from: components)!
    }
    
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self.date)
    }
    
    
    var accentColor: Color {
        if let company = CompanyColor(rawValue: self.operatorString ?? "") {
            return company.color
        } else {
            return Color.orange
        }
    }
    
    var routeTitle: String {
        return "\(origin?.ident ?? "ZZZZ")-\(destination?.ident ?? "ZZZZ")"
    }
    
    var adjustedTotalTime: Double {
        switch self.flightType {
        case .military: return (totalTime ?? 0.0) + Double(sorties ?? 1) * 0.3
        default : return totalTime ?? 0.0
        }
    }
    
    var distance: Double? {
        if let actualDistance {
            return Double(actualDistance)
        } else if let oloc = origin?.location, let dloc = destination?.location {
            let originCoordinate = CLLocation(latitude: oloc.latitude, longitude: oloc.longitude)
            let destinationCoordinate = CLLocation(latitude: dloc.latitude, longitude: dloc.longitude)
            return originCoordinate.distance(from: destinationCoordinate) / 1609.34
        }
        return nil
    }
    
    var dayLandings: Int {
        var count = 0
        for landing in landings ?? [] {
            if landing.type?.isDay ?? false {
                count += landing.count
            }
        }
        return count
    }
    var nightLandings: Int {
        var count = 0
        for landing in landings ?? [] {
            if !(landing.type?.isDay ?? true) {
                count += landing.count
            }
        }
        return count
    }
    var totalApproaches: Int {
        approaches?.reduce(0) { $0 + $1.count } ?? 0
    }
    
    var multi: Double? {
        if aircraft?.aircraftType == .Fixed_Wing_Multi_Engine {
            return totalTime
        } else {
            return nil
        }
    }
    var single: Double? {
        if aircraft?.aircraftType == .Fixed_Wing_Single_Engine {
            return totalTime
        } else {
            return nil
        }
    }
    var tilt: Double? {
        if aircraft?.aircraftType == .Hybrid_Lift {
            return totalTime
        } else {
            return nil
        }
    }
    var helicopter: Double? {
        if aircraft?.aircraftType == .Rotorcraft {
            return totalTime
        } else {
            return nil
        }
    }
    var glider: Double? {
        if aircraft?.aircraftType == .Glider {
            return totalTime
        } else {
            return nil
        }
    }
    
    //Decoadable part
    enum CodingKeys: String, CodingKey {
        case ident, faFlightId, flightNumber
        case scheduledOut, estimatedOut, actualOut
        case scheduledOff, estimatedOff, actualOff
        case scheduledOn, estimatedOn, actualOn
        case scheduledIn, estimatedIn, actualIn
        case filedEte, actualDistance
        case routeDistance, filedAirspeed, filedAltitude, route
        case gateOrigin, gateDestination
        case actualRunwayOff, actualRunwayOn
        case registration, aircraftType
        case operatorString = "operator"
        case origin, destination
        case type, passengers, cargo, combat, nvg
        
        
    }
    
    //MARK: Inits
    init(source: Import) {
        self.source = source
    }
    
    init(type: FlightType) {
        self.flightType = type
    }
    init(ident: String? = nil, origin: Airport? = nil, destination: Airport? = nil, aircraft: Aircraft? = nil) {
        self.ident = ident
        self.origin = origin
        self.destination = destination
        self.aircraft = aircraft
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ident = try container.decode(String.self, forKey: .ident)
        self.faFlightId = try container.decode(String.self, forKey: .faFlightId)
        self.operatorString = try container.decodeIfPresent(String.self, forKey: .operatorString)
        self.flightNumber = try container.decodeIfPresent(String.self, forKey: .flightNumber)
        
        //Filed Flight Data
        self.filedEte = try container.decodeIfPresent(Int.self, forKey: .filedEte)
        self.routeDistance = try container.decodeIfPresent(Int.self, forKey: .routeDistance)
        self.filedAirspeed = try container.decodeIfPresent(Int.self, forKey: .filedAirspeed)
        self.filedAltitude = try container.decodeIfPresent(Int.self, forKey: .filedAltitude)
        self.route = try container.decodeIfPresent(String.self, forKey: .route)
        self.actualDistance = try container.decodeIfPresent(Int.self, forKey: .actualDistance)
        
        //Gates and Baggage claim
        self.gateOrigin = try container.decodeIfPresent(String.self, forKey: .gateOrigin)
        self.gateDestination = try container.decodeIfPresent(String.self, forKey: .gateDestination)
        self.actualRunwayOff = try container.decodeIfPresent(String.self, forKey: .actualRunwayOff)
        self.actualRunwayOn = try container.decodeIfPresent(String.self, forKey: .actualRunwayOn)

        //Times
        self.scheduledOut = try container.decodeIfPresent(Date.self, forKey: .scheduledOut)
        self.scheduledOff = try container.decodeIfPresent(Date.self, forKey: .scheduledOff)
        self.scheduledOn = try container.decodeIfPresent(Date.self, forKey: .scheduledOn)
        self.scheduledIn = try container.decodeIfPresent(Date.self, forKey: .scheduledIn)
        
        self.actualOut = try container.decodeIfPresent(Date.self, forKey: .actualOut)
        self.actualOff = try container.decodeIfPresent(Date.self, forKey: .actualOff)
        self.actualOn = try container.decodeIfPresent(Date.self, forKey: .actualOn)
        self.actualIn = try container.decodeIfPresent(Date.self, forKey: .actualIn)
        
        self.estimatedOut = try container.decodeIfPresent(Date.self, forKey: .estimatedOut)
        self.estimatedOff = try container.decodeIfPresent(Date.self, forKey: .actualOff)
        self.estimatedOn = try container.decodeIfPresent(Date.self, forKey: .actualOn)
        self.estimatedIn = try container.decodeIfPresent(Date.self, forKey: .estimatedIn)
        
        //Military stuff
        self.passengers = try container.decodeIfPresent(Int.self, forKey: .passengers)
        self.cargo = try container.decodeIfPresent(Int.self, forKey: .cargo)
        self.combat = try container.decodeIfPresent(Double.self, forKey: .combat)
        self.nvg = try container.decodeIfPresent(Double.self, forKey: .nvg)

        let typeStr = try container.decodeIfPresent(String.self, forKey: .type)
        if typeStr == "Airline" { self.flightType = .airline } else { self.flightType = .generalAviation }
        //Airport Match
        if let origin = try container.decodeIfPresent(FlightAwareAirport.self, forKey: .origin) {
            //self.origin = Airport(fromDBWithID: origin.codeIcao ?? "", idType: .icao)
        }
        if let destination = try container.decodeIfPresent(FlightAwareAirport.self, forKey: .destination) {
            //self.destination = Airport(fromDBWithID: destination.codeIcao ?? "", idType: .icao)
        }
        
        //Aircraft Match
        if let reg = try container.decodeIfPresent(String.self, forKey: .registration) {
            //self.aircraft = Aircraft(fromDBWithID: reg, idType: .registration)
            if self.aircraft?.icaoCode == nil {
                self.aircraft?.icaoCode = try container.decodeIfPresent(String.self, forKey: .aircraftType)
            }
        }
        if let out = self.actualOut, let inn = self.actualIn {
            self.totalTime = inn.timeIntervalSince(out) / 3600.0
        }
        
    }
}

struct Position: Codable {
    var altitude: Int?  //Aircraft altitude in hundreds of feet
    var altitudeChange: String?  //C when the aircraft is climbing, D when descending, and - when the altitude is being maintained.  Allowed: C┃D┃-
    var groundspeed: Int?  //Most recent groundspeed (knots)
    var heading: Int?  //Aircraft heading in degrees (0-360)  Constraints: Min 0┃Max 360
    var latitude: Double?  //Most recent latitude position
    var longitude: Double?  //Most recent longitude position
    var timestamp: Date?  //Time that position was received
    var updateType: UpdateType?  //P=projected, O=oceanic, Z=radar, A=ADS-B, M=multilateration, D=datalink, X=surface and near surface (ADS-B and ASDE-X), S=space-based, V=virtual event  Allowed: P┃O┃Z┃A┃M┃D┃X┃S┃V┃
    
    var coordinate: CLLocationCoordinate2D? {
        if let latitude, let longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}

