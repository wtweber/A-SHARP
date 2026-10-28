//
//  TestFlightDetailView.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI

struct TestDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var flight: Flight?
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                HStack(alignment: .center) {
                    let imageName: String = "Logo/\(flight?.operatorString ?? "")"
                    if imageExists(named: imageName) {
                        Image(imageName)
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    VStack(alignment: .leading) {
                        Text("\(flight?.ident ?? "") • \(Date.now.formatted(date: .abbreviated, time: .omitted))").foregroundStyle(.secondary).font(.caption)
                        Text("\(flight?.origin?.ident ?? "") to \(flight?.destination?.ident ?? "")").font(.title)
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
            .padding(.top, 25)
            .padding(.bottom, 5)
            .padding([.horizontal])
            
            List {
                Section {
                    VStack(alignment: .leading) {
                        tolRow(airport: flight?.origin, scheduled1: flight?.scheduledOut, actual1: flight?.actualOut, scheduled2: flight?.scheduledOff, actual2: flight?.actualOff, depart: true)
                        HStack {
                            if let timeString = flight?.totalTime?.hourClock {
                                Image(systemName: "clock").font(.caption2)
                                Text(timeString).font(.caption2)
                            }
                            VStack { Divider() }
                        }
                        tolRow(airport: flight?.destination, scheduled1: flight?.scheduledOn, actual1: flight?.actualOn, scheduled2: flight?.scheduledIn, actual2: flight?.actualIn, depart: false)
                    }.listRowBackground(Color.viewBackground)
                }
                if let aircraft = flight?.aircraft {
                    Section {
                        VStack(alignment: .listRowSeparatorLeading) {
                            AircraftImageView(image: aircraft.image, operatorString: flight?.operatorString)
                            HStack(alignment: .firstTextBaseline) {
                                Text(aircraft.registration ?? "No registration").font(.largeTitle)
                                if let serialNumber = aircraft.serialNumber {
                                    Text("(\(serialNumber))").font(.caption)
                                }
                            }
                            HStack(alignment: .firstTextBaseline) {
                                Text(aircraft.manufacturer ?? "").font(.title)
                                Text(aircraft.model ?? "").font(.body)
                            }
                            Text("\(aircraft.flights?.count ?? 0) flights, \(aircraft.totalFlightTime.formatted(.number.precision(.fractionLength(2)))) hours").font(.caption)
                        }.listRowBackground(Color.viewBackground)
                    }
                }
                Section {
                    DoubleRow(title: "Total Time", value: flight?.totalTime).listRowBackground(Color.viewBackground)
                    if let pic = flight?.pic  {
                        DoubleRow(title: "PIC", value: pic).listRowBackground(Color.viewBackground)
                    }
                    if let sic = flight?.sic {
                        DoubleRow(title: "SIC", value: sic).listRowBackground(Color.viewBackground)
                    }
                    if let xc = flight?.crossCountry {
                        DoubleRow(title: "Cross Country", value: xc).listRowBackground(Color.viewBackground)
                    }
                    if let dg = flight?.dualGiven {
                        DoubleRow(title: "Dual Given", value: dg).listRowBackground(Color.viewBackground)
                    }
                    if let dr = flight?.dualRecieved {
                        DoubleRow(title: "Dual Recieved", value: dr).listRowBackground(Color.viewBackground)
                    }
                    if let night = flight?.night {
                        DoubleRow(title: "Night", value: night).listRowBackground(Color.viewBackground)
                    }
                    if let ait = flight?.acutalInstrument {
                        DoubleRow(title: "Actual Ins.", value: ait).listRowBackground(Color.viewBackground)
                    }
                    if let sit = flight?.simulatedInstrument {
                        DoubleRow(title: "Simulated Ins.", value: sit).listRowBackground(Color.viewBackground)
                    }
                }
                Section {
                    if !(flight?.approaches?.isEmpty ?? true) {
                        ForEach(flight?.approaches ?? [], id: \.self) { app in
                            IntRow(title: app.type?.name ?? "Unknown Type", value: app.count).listRowBackground(Color.viewBackground)
                        }
                    } else {
                        Text("No approaches.").listRowBackground(Color.viewBackground)
                    }
                } header: {
                    Text("Approaches")
                }
                Section {
                    if !(flight?.landings?.isEmpty ?? true) {
                        ForEach(flight?.landings ?? [], id: \.self) { ldg in
                            IntRow(title: ldg.type?.name ?? "Unknown Type", value: ldg.count).listRowBackground(Color.viewBackground)
                        }
                    } else {
                        Text("No landings.").listRowBackground(Color.viewBackground)
                    }
                } header: {
                    Text("Landings")
                }
                if !(flight?.crew?.isEmpty ?? true) {
                    Section {
                        ForEach(flight?.crew ?? [], id: \.self) { crewMember in
                            Text(crewMember.fullName).listRowBackground(Color.viewBackground)
                        }
                    } header: {
                        Text("Crew members").listRowBackground(Color.viewBackground)
                    }
                }
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
            .toolbar(.hidden, for: .navigationBar)
        }.background(Color.viewBackground)
    }
    
    
    
}
