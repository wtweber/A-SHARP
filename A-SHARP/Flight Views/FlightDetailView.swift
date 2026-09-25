//
//  FlightDetailView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct FlightDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.windowSize) private var windowSize
    
    @State var flight: Flight?
    @Binding var overlayHeight: CGFloat
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
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
                        Label("Close", systemImage: "xmark")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.primary)
                            .clipShape(.circle)
                    }.buttonStyle(.plain)
                    
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
                        }
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
                            }
                        }
                    }
                    Section {
                        DoubleRow(title: "Total Time", value: flight?.totalTime)
                        if let pic = flight?.pic  {
                            DoubleRow(title: "PIC", value: pic)
                        }
                        if let sic = flight?.sic {
                            DoubleRow(title: "SIC", value: sic)
                        }
                        if let xc = flight?.crossCountry {
                            DoubleRow(title: "Cross Country", value: xc)
                        }
                        if let dg = flight?.dualGiven {
                            DoubleRow(title: "Dual Given", value: dg)
                        }
                        if let dr = flight?.dualRecieved {
                            DoubleRow(title: "Dual Recieved", value: dr)
                        }
                        if let night = flight?.night {
                            DoubleRow(title: "Night", value: night)
                        }
                        if let ait = flight?.acutalInstrument {
                            DoubleRow(title: "Actual Ins.", value: ait)
                        }
                        if let sit = flight?.simulatedInstrument {
                            DoubleRow(title: "Simulated Ins.", value: sit)
                        }
                    }
                    Section {
                        if !(flight?.approaches?.isEmpty ?? true) {
                            ForEach(flight?.approaches ?? [], id: \.self) { app in
                                IntRow(title: app.type?.name ?? "Unknown Type", value: app.count)
                            }
                        } else {
                            Text("No approaches.")
                        }
                    } header: {
                        Text("Approaches")
                    }
                    Section {
                        if !(flight?.landings?.isEmpty ?? true) {
                            ForEach(flight?.landings ?? [], id: \.self) { ldg in
                                IntRow(title: ldg.type?.name ?? "Unknown Type", value: ldg.count)
                            }
                        } else {
                            Text("No landings.")
                        }
                    } header: {
                        Text("Landings")
                    }
                    if !(flight?.crew?.isEmpty ?? true) {
                        Section {
                            ForEach(flight?.crew ?? [], id: \.self) { crewMember in
                                Text(crewMember.fullName)
                            }
                        } header: {
                            Text("Crew members")
                        }
                    }
                }.listStyle(.insetGrouped)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
    
    
}

/*#Preview {
 FlightDetailView()
 }*/

struct tolRow: View {
    @State var airport: Airport?
    
    @State var scheduled1: Date?
    @State var actual1: Date?
    @State var scheduled2: Date?
    @State var actual2: Date?
    
    @State var depart: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: depart ? "airplane.departure" : "airplane.arrival")
                Text("\(airport?.ident ?? "") • \(airport?.name ?? "")")
            }
            
            if actual1 != nil {
                Text(depart ? "Out" : "On").font(.caption)
                HStack(alignment: .firstTextBaseline) {
                    Text("\(actual1?.formatted(date: .omitted, time: .shortened) ?? "")").font(.largeTitle)
                    Text("\(scheduled1?.formatted(date: .omitted, time: .shortened) ?? "")").font(.caption)
                    Spacer()
                }
            }
            if actual2 != nil {
                Text(depart ? "Off" : "In").font(.caption)
                HStack(alignment: .firstTextBaseline) {
                    Text("\(actual2?.formatted(date: .omitted, time: .shortened) ?? "")").font(.largeTitle)
                    Text("\(scheduled2?.formatted(date: .omitted, time: .shortened) ?? "")").font(.caption)
                    Spacer()
                }
            }
            
        }
    }
}
