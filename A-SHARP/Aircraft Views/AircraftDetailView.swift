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
    @Binding var overlayHeight: CGFloat
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(aircraft.registration ?? "No registration").font(.largeTitle)
                            if let serialNumber = aircraft.serialNumber {
                                Text("(\(serialNumber))").font(.caption)
                            }
                        }
                        Spacer()
                        Button { dismiss() } label: {
                            Label("Close", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.primary)
                                .clipShape(.circle)
                        }.buttonStyle(.plain)
                    }
                    HStack(alignment: .firstTextBaseline) {
                        Text(aircraft.manufacturer ?? "").font(.title)
                        Text(aircraft.model ?? "").font(.body)
                    }
                    if let t = aircraft.aircraftType, let cat = aircraft.aircraftCatagory {
                        Text("\(t.description) \(cat.description)").font(.caption)
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
                    if let image = aircraft.image {
                        Section {
                            VStack(alignment: .leading) {
                                AircraftImageView(image: image, operatorString: aircraft.flights?.first?.operatorString ?? "")
                                Link(destination: aircraft.imageLink ?? URL(string: "https://www.planespotters.net")!) {
                                    if let photographer = aircraft.photographer {
                                        Label(photographer, systemImage: "c.circle")
                                    }
                                }.padding(.top, 5)
                            }
                        }
                    }
                    Section {
                        ForEach(aircraft.flights ?? []) { flight in
                            FlightRowView(flight: flight)
                        }
                    } header: {
                        Text("\(aircraft.flights?.count ?? 0) flights for \(aircraft.totalFlightTime.formatted(.number.precision(.fractionLength(2)))) hours").padding(.top)
                    }
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}

