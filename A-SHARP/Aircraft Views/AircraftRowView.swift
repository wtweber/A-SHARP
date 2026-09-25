//
//  AircraftRowView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct AircraftRowView: View {
    @State var aircraft: Aircraft
    @State var operatorString: String?
    
    var body: some View {
        HStack(alignment: .top) {
            AircraftImageView(image: aircraft.image, operatorString: operatorString ?? "")
            VStack(alignment: .leading) {
                Text(aircraft.registration ?? "No registration").font(.title)
                Text(aircraft.manufacturer ?? "").font(.body)
                Text(aircraft.model ?? "").font(.caption)
                Text("\(aircraft.flights?.count ?? 0) flights, \(aircraft.totalFlightTime.formatted(.number.precision(.fractionLength(2)))) hours").font(.caption)
            }
        }
    }
}
