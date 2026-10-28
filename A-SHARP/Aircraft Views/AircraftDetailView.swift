//
//  AircraftDetailView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct AircraftDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.windowSize) private var windowSize
    
    @State var aircraft: Aircraft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                HStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text(aircraft.registration ?? "No registration").font(.largeTitle)
                        if let serialNumber = aircraft.serialNumber {
                            Text("(\(serialNumber))").font(.caption)
                        }
                    }
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(5)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                }
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(aircraft.manufacturer ?? "").font(.title)
                        Text(aircraft.model ?? "").font(.body)
                    }
                    VStack(alignment: .leading) {
                        Text(aircraft.manufacturer ?? "").font(.title)
                        Text(aircraft.model ?? "").font(.body)
                    }
                }
                
                if let t = aircraft.aircraftType, let cat = aircraft.aircraftCatagory {
                    Text("\(t.description) \(cat.description)").font(.caption)
                }
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
            .padding([.horizontal])
            List {
                if let image = aircraft.image {
                    VStack(alignment: .leading) {
                        AircraftImageView(image: image, operatorString: aircraft.flights?.first?.operatorString ?? "")
                        Link(destination: aircraft.imageLink ?? URL(string: "https://www.planespotters.net")!) {
                            if let photographer = aircraft.photographer {
                                Label(photographer, systemImage: "c.circle")
                            }
                        }.padding(.top, 5)
                    }.listRowBackground(Color.viewBackground)
                }
                Section {
                    ForEach(aircraft.flights ?? []) { flight in
                        FlightRowView(flight: flight).listRowBackground(Color.viewBackground)
                    }
                } header: {
                    Text("\(aircraft.flights?.count ?? 0) flights for \(aircraft.totalFlightTime.formatted(.number.precision(.fractionLength(2)))) hours").padding(.top)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
        }.background(Color.viewBackground)
    }
}

