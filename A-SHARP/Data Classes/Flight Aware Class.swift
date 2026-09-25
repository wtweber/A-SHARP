//
//  Flight Aware Class.swift
//  A-SHARP
//
//  Created by William Weber on 1/29/26.
//

import Foundation
import MapKit

struct FlightAwareFlightsResponce: Decodable {
    let flights: [Flight]
}
struct FlightAwareRawResponce: Decodable {
    let flights: [FlightAwareFlight]
}
struct FlightAwarePositions: Decodable {
    let actualDistance: Int?
    let positions: [Position]?
    
    /*enum CodingKeys: String, CodingKey {
        case actualDistance = "actual_distance"
        case positions
    }*/
}

struct FlightAwareFlight: Decodable, Identifiable, Equatable {
    let id: UUID = UUID()
    
    static func == (lhs: borrowing FlightAwareFlight, rhs: borrowing FlightAwareFlight) -> Bool {
        return lhs.faFlightId == rhs.faFlightId
    }

    var ident: String  //Either the operator code followed by the flight number for the flight (for commercial flights) or the aircraft's registration (for general aviation).
    var faFlightId: String  //Unique identifier assigned by FlightAware for this specific flight. If the flight is diverted, the new leg of the flight will have a duplicate fa_flight_id.
    var operatorString: String?  //ICAO code, if exists, of the operator of the flight, otherwise the IATA code
    var atcIdent: String?  //The ident of the flight for Air Traffic Control purposes, when known and different than ident.
    var identIcao: String?  //The ICAO operator code followed by the flight number for the flight (for commercial flights)
    var identIata: String?  //The IATA operator code followed by the flight number for the flight (for commercial flights)
    
    var operatorIcao: String?  //ICAO code of the operator of the flight.
    var operatorIata: String?  //IATA code of the operator of the flight.
    var flightNumber: String?  //Bare flight number of the flight.
    
    var inboundFaFlightId: String?  //Unique identifier assigned by FlightAware for the previous flight of the aircraft serving this flight.
    var codeshares: [String] = []  //List of any ICAO codeshares operating on this flight.
    var codesharesIata: [String] = [] //List of any IATA codeshares operating on this flight.
    
    var blocked: Bool? //Flag indicating whether this flight is blocked from public viewing.
    var diverted: Bool?  //Flag indicating whether this flight was diverted.
    var cancelled: Bool?  //Flag indicating that the flight is no longer being tracked by FlightAware. There are a number of reasons this could happen including cancellation by the airline, but that will not always be the case.
    var positionOnly: Bool? //Flag indicating that this flight does not have a flight plan, schedule, or other indication of intent available.
    
    var departureDelay: Int?  //Departure delay (in seconds) based on either actual or estimated gate departure time. If gate time is unavailable then based on runway departure time. A negative value indicates the flight is early.
    var arrivalDelay: Int?  //Arrival delay (in seconds) based on either actual or estimated gate arrival time. If gate time is unavailable then based on runway arrival time. A negative value indicates the flight is early.
    var filedEte: Int? //Runway-to-runway filed duration (seconds).
    var progressPercent: Int? //The percent completion of a flight, based on runway departure/arrival. Null for en route position-only flights. Constraints: Min 0┃Max 100
    var status: String?  //Human-readable summary of flight status.
    
    //Filed Flight Data
    var routeDistance: Int?  //Planned flight distance (statute miles) based on the filed route. May vary from actual flown distance.
    var filedAirspeed: Int?  //Filed IFR airspeed (knots).
    var filedAltitude: Int?  //Filed IFR altitude (100s of feet).
    var route: String?  //The textual description of the flight's route.
    
    //Actual Flight Data
    var actualDistance: Int?  //Distance (in miles) flown as of the latest position point. Will include distance from the origin airport to the first position point. If the flight has been completed, will include the distance from the last position point to the destination airport. If surface positions are enabled, will include distance traveled on the ground as part of the flight track and actual distance flown calculations. Estimated positions present in the flight track will not be part of the actual distance flown calculation.
    //var positions: [Position] = []
    
    //Gates and Baggage claim
    var baggageClaim: String?  //Baggage claim location at the destination airport.
    var gateOrigin: String?  //Departure gate at the origin airport.
    var gateDestination: String?  //Arrival gate at the destination airport.
    var terminalOrigin: String?  //Departure terminal at the origin airport.
    var terminalDestination: String?  //Arrival terminal at the destination airport.
    var actualRunwayOff: String?
    var actualRunwayOn: String?
    
    var type: String?  //Whether this is a commercial or general aviation flight. ⤵
    
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
    
    var foresightPredictionsAvailable: Bool?
    
    //Aircraft Data
    var registration: String?  //Aircraft registration (tail number) of the aircraft, when known.
    var aircraftType: String?  //Aircraft type will generally be ICAO code, but IATA code will be given when the ICAO code is not known.
    var seatsCabinBusiness: Int?  //Number of seats in the business class cabin.
    var seatsCabinCoach: Int?  //Number of seats in the coach cabin.
    var seatsCabinFirst: Int?
    
    var destination: FlightAwareAirport?
    var origin: FlightAwareAirport?
    
    enum CodingKeys: String, CodingKey {
        case ident, faFlightId
        case scheduledOut, estimatedOut, actualOut
        case scheduledOff, estimatedOff, actualOff
        case scheduledOn, estimatedOn, actualOn
        case scheduledIn, estimatedIn, actualIn
        case atcIdent, identIcao, identIata
        case operatorIcao, operatorIata, flightNumber
        case inboundFaFlightId, codeshares, codesharesIata
        case blocked, diverted, cancelled, positionOnly
        case departureDelay, arrivalDelay, filedEte, progressPercent, status
        case routeDistance, filedAirspeed, filedAltitude, route
        case baggageClaim, gateOrigin, gateDestination
        case terminalOrigin, terminalDestination
        case actualRunwayOff, actualRunwayOn
        case type, foresightPredictionsAvailable
        case registration, aircraftType
        case operatorString = "operator"
        case origin, destination
    }
}

struct FlightAwareAirport: Decodable {  //FlightAirportRef: Information for this flight's destination airport.
    var code: String? //ICAO/IATA/LID code or string indicating the location where tracking of the flight began/ended for position-only flights.
    var codeIcao: String?  //ICAO code
    var codeIata: String? //IATA code
    var codeLid: String?  //LID code
    var timezone: String?  //Applicable timezone for the airport, in the TZ database format
    var name: String?  //Common name of airport
    var city: String? //Closest city to the airport
    var airportInfoUrl: URL?  //The URL to more information about the airport. Will be null for position-only flights.
    
    var airportCode: String?
    var elevation: Double?
    var longitude: Double?
    var latitude: Double?
    var wikiUrl: String?
    
    var location: CLLocation? {
        if let latitude, let longitude {
            return .init(latitude: latitude, longitude: longitude)
        } else { return nil }
    }
}


func getRawFAFlights(_ callsign: String?, date: Date?) async throws -> [FlightAwareFlight]? {
    guard let callsign, let date else {
        print("Missing data")
        return nil
    }
    var url = URLComponents(string: Constants.FLIGHT_API_ENDPOINT.appending("/\(callsign)"))//URL(string: Constants.FLIGHT_API_ENDPOINT)!
    url?.queryItems = [URLQueryItem(name: "start", value: date.dateStamap),
                       URLQueryItem(name: "end", value: Calendar.current.date(byAdding: .day, value: 1, to: date)!.dateStamap)]
    var request = URLRequest(url: url!.url!)
    request.httpMethod = "GET"
    request.addValue("ZqOTne2DhatI2bsFdf9y76gLuQwH1ajn", forHTTPHeaderField: "x-apikey")
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        print(try JSONSerialization.jsonObject(with: data, options: []))
        let decoder = JSONDecoder().FlightAwareDecoder
        let wrapper = try decoder.decode(FlightAwareRawResponce.self, from: data)
        return wrapper.flights
    } catch {
        print(error.localizedDescription)
        throw error
    }
}
