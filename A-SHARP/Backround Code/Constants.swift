//
//  Constants.swift
//  A-SHARP
//
//  Created by William Weber on 12/19/25.
//

import Foundation

struct Constants {
    static let FLIGHT_API_ENDPOINT = "https://aeroapi.flightaware.com/aeroapi/flights/"
    static let FA_API_KEY = Bundle.main.infoDictionary?["FA_API_KEY"] as? String
}
