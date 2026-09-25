//
//  Airport.swift
//  A-SHARP Data Formatter
//
//  Created by William Weber on 1/15/26.
//

import Foundation
import SQLite3
import SwiftData
import MapKit
import SwiftUI

//MARK: AIRPORT
@Model
class Airport {
    var icao: String?
    var iata: String?
    var name: String?
    
    var city: String?
    var wiki: String?
    //var country: String?
    
    var latitude: Double?
    var longitude: Double?
    var altitude: Double?

    var timeZoneString: String?
    var airportType: AirportType?
    
    var continent: String?
    var isoCountryCode: String?
    var isoRegionCode: String?
    
    var gpsCode: String?
    var localCode: String?
    
    var homeLink: String?
    var keyWords: String?
    
    //SwiftData Relations
    var departures: [Flight]?
    var arrivals: [Flight]?

    //Calculated Values
    var ident: String {
        if let icao {
            return icao
        } else if let iata {
            return iata
        } else if let localCode {
            return localCode
        } else if let gpsCode {
            return gpsCode
        } else {
            return "ZZZZ"
        }
    }
    
    var allFlights: [Flight] {
        let f = (departures ?? []) + (arrivals ?? [])
        return f.sorted(by: { $0.actualOut ?? Date.distantPast > $1.actualOut ?? Date.distantPast })
    }
    
    var timeZone: TimeZone? {
        return TimeZone(identifier: timeZoneString ?? "utc")
    }
    
    var location: CLLocationCoordinate2D? {
        if let latitude, let longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else { return nil }
        
    }
    
    var locationName: String? {
        var locationComps: [String] = []
        if let city {
            locationComps.append(city)
        }
        if let isoCountryCode {
            let currentLocale = Locale.current
            if let country = currentLocale.localizedString(forRegionCode: isoCountryCode) {
                locationComps.append(country)
            }
        }
        if locationComps.isEmpty { return nil }
        return locationComps.joined(separator: ", ")
    }
    var countryname: String? {
        let currentLocale = Locale.current
        return currentLocale.localizedString(forRegionCode: isoCountryCode ?? "")
    }
    
    init() { }
    
    init(icao: String?, iata: String?, name: String?, city: String?,
         wiki: String?, type_str: String?,
         latitude: Double?, longitude: Double?, altitude: Double?, tzString: String?,
         continent: String?, isoCountryCode: String?, isoRegionCode: String?,
         gpsCode: String?, localCode: String?, homeLink: String?, keyWords: String?) {
        self.icao = icao
        self.iata = iata
        self.name = name
        self.city = city
        self.wiki = wiki
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timeZoneString = tzString
        self.airportType = AirportType(rawValue: type_str ?? "")
        self.continent = continent
        self.isoCountryCode = isoCountryCode
        self.isoRegionCode = isoRegionCode
        self.gpsCode = gpsCode
        self.localCode = localCode
        self.homeLink = homeLink
        self.keyWords = keyWords
    }
}

extension Airport {
    func hasID(_ id: String?) -> Bool {
        if self.icao == id || self.iata == id || self.gpsCode == id || self.localCode == id {
            return true
        } else {
            return false
        }
    }
}

extension Airport {
    var flightCount: Int {
        return (departures?.count ?? 0) + (arrivals?.count ?? 0)
    }
}
