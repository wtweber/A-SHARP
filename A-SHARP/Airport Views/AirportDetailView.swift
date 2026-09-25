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
    @Binding var overlayHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                HStack (alignment: .top) {
                    Text(airport?.name ?? "").font(.title)
                    Spacer()
                    Button { dismiss() } label: {
                        Label("Close", systemImage: "xmark")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.primary)
                            .clipShape(.circle)
                    }.buttonStyle(.plain)
                }.padding(.bottom, 0)
                HStack {
                    if let icao = airport?.icao {
                        Text(icao)
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.secondary, lineWidth: 1) // Draws the outline
                            )
                    }
                    if let iata = airport?.iata {
                        Text(iata)
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.secondary, lineWidth: 1) // Draws the outline
                            )
                    }
                    if let gps = airport?.gpsCode {
                        Text(gps)
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.secondary, lineWidth: 1) // Draws the outline
                            )
                    }
                    if let local = airport?.localCode {
                        Text(local)
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.secondary, lineWidth: 1) // Draws the outline
                            )
                    }
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
            }.padding([.horizontal, .top])
                .padding(.bottom, 5)
                .background(Color(uiColor: .systemGroupedBackground))
                .gesture(
                    DragGesture(minimumDistance: 50, coordinateSpace: .global)
                        .onChanged { value in
                            withAnimation(.spring()) {
                                overlayHeight =  max(0, windowSize.height - value.location.y + 50)
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                let releaseHeight = windowSize.height - value.predictedEndLocation.y
                                if releaseHeight < windowSize.height * 0.3 {
                                    overlayHeight = windowSize.height * 0.30
                                } else if releaseHeight < windowSize.height * 0.75 {
                                    overlayHeight = windowSize.height * 0.5
                                } else {
                                    overlayHeight = .infinity
                                }
                            }
                        }
                )
            List {
                Section {
                    ForEach(airport?.allFlights ?? []) { flight in
                        FlightRowView(flight: flight)
                    }
                } header: {
                    Text("\(airport?.allFlights.count ?? 0) Flights")
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}
