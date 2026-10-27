//
//  AirportDetailView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import FlagsKit

struct AirportDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.windowSize) private var windowSize
    
    @State var airport: Airport?
    //@Binding var overlayHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                HStack {
                    Text(airport?.name ?? "").font(.title)
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(5)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                }.padding(.bottom, 0)
                HStack {
                    if let icao = airport?.icao { IdentBox(ident: icao) }
                    if let iata = airport?.iata { IdentBox(ident: iata) }
                    if let gps = airport?.gpsCode { IdentBox(ident: gps) }
                    if let local = airport?.localCode { IdentBox(ident: local) }
                }.font(.caption).foregroundStyle(Color.secondary)
                HStack {
                    if let iso = airport?.isoCountryCode {
                        FlagView(countryCode: iso, style: .circle)
                            .frame(width: 30, height: 30)
                    }
                    VStack(alignment: .leading) {
                        Text(airport?.locationName ?? "")
                        if let tz = airport?.timeZone {
                            Text("\(tz.localizedName(for: .standard, locale: .current) ?? "") (\(tz.gmtString))").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
            .padding([.horizontal])
            List {
                Section {
                    ForEach(airport?.allFlights ?? []) { flight in
                        FlightRowView(flight: flight).listRowBackground(Color.viewBackground)
                    }
                } header: {
                    Text("\(airport?.allFlights.count ?? 0) Flights")
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
            //.background(Color.viewBackground)
        }.background(Color.viewBackground)
    }
}
