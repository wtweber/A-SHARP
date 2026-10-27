//
//  FlightRowView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct FlightRowView: View {
    @State var flight: Flight
    
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text(flight.date, format: .dateTime.month())
                Text(flight.date, format: .dateTime.day()).font(.headline)
                Text(flight.date, format: .dateTime.year())
            }
            Divider()
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(flight.origin?.ident ?? "").font(.headline)
                        Text(flight.actualOut?.formatedTimeString(timeZone: flight.origin?.timeZone ?? nil) ?? "")
                    }
                    TimeDivider(time: flight.totalTime)
                    VStack(alignment: .trailing) {
                        Text(flight.destination?.ident ?? "").font(.headline)
                        Text(flight.actualIn?.formatedTimeString(timeZone: flight.destination?.timeZone ?? nil) ?? "")
                    }
                }
                
                HStack {
                    let imageName: String = "Logo/\(flight.operatorString ?? "")"
                    if imageExists(named: imageName) {
                        Image(imageName).resizable().frame(maxWidth: 20, maxHeight: 20)
                    }
                    Text(flight.ident ?? "").font(.default)
                    Spacer()
                }
            }
        }
    }
}

