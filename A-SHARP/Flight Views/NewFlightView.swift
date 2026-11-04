//
//  NewFlightView.swift
//  A-SHARP
//
//  Created by William Weber on 11/3/26.
//

import SwiftUI

struct NewFlightView: View {
    @AppStorage("defaultOperator") private var defaultOperator: String = "UAL2769"
    @AppStorage("defaultSeat") private var defaultSeat: Seat = .capt
    //@AppStorage("defaultRole") private var defaultRole: Role = .pm
    
    @State var flightNumber = ""
    @State var date: Date = Date()
    
    @State var flights: [FlightAwareFlight] = []
    @State var selectedFlight: FlightAwareFlight?
    
    @State var seat: Seat = .fo
    @State var role: Role = .pm
    
    @State var approaches: [Approach] = []
    @State var landings: [Landing] = []
    
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .day, value: 1, to: Date())!
        let start = calendar.date(byAdding: .day, value: -7, to: Date())!
        return start...end
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Flight number")
                    TextField("Flight number", text: $flightNumber)
                        .multilineTextAlignment(.trailing)
                }
                DatePicker("Zulu Date",
                           selection: $date,
                           in: dateRange,
                           displayedComponents: .date)
                Button {
                    //TODO: Search Flight Aware
                    Task {
                        do {
                            if let faFlights = try await getRawFAFlights(flightNumber, date: date) {
                                flights = faFlights.filter({$0.progressPercent == 100})
                            }
                        } catch {
                            print("error with flight aware")
                        }
                    }
                } label: {
                    Label("Search FlightAware", systemImage: "magnifyingglass")
                }
            }
            if !flights.isEmpty && selectedFlight == nil {
                ForEach(flights) { flight in
                    Button {
                        selectedFlight = flight
                    } label: {
                        flightAwareRow(flight: flight)
                            .contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }
            }
            Section {
                flightAwareDetailView(selectedFlight: $selectedFlight)
            }
            if selectedFlight != nil {
                VStack(alignment: .leading) {
                    Text("Seat")
                    Section {
                        Picker("Seat", selection: $seat) {
                            Text("Captain").tag(Seat.capt)
                            Text("First Officer").tag(Seat.fo)
                        }.pickerStyle(.segmented)
                    }
                }
                VStack(alignment: .leading) {
                    Text("Role")
                    Section {
                        Picker("Role", selection: $role) {
                            Text("Pilot Flying").tag(Role.pf)
                            Text("Pilot Monitoring").tag(Role.pm)
                        }.pickerStyle(.segmented)
                    }
                }
            }
            if role == .pf {
                Section {
                    List(approaches) { approach in
                        HStack {
                            Text(approach.type?.name ?? "Unknown")
                            Spacer()
                            Text(approach.count, format: .number)
                        }
                    }
                } header: { Text("Approaches") }
                Section {
                    List(landings) { landing in
                        HStack {
                            Text(landing.type?.name ?? "Unknown")
                            Spacer()
                            Text(landing.count, format: .number)
                        }
                    }
                } header: { Text("Landings") }
            }
            if selectedFlight != nil {
                Section {
                    Button {
                        //TODO: Save flight
                    } label: {
                        Label("Save Flight", systemImage: "airplane.ticket")
                    }
                }
            }
        }
        .onAppear {
            flightNumber = defaultOperator
            seat = defaultSeat
        }
        .onChange(of: role) {
            switch role {
            case .pf:
                approaches = [Approach(type: .ILS, count: 1)]
                landings = [Landing(type: .FieldFullStop_Day, count: 1)]
            case .pm:
                approaches = []
                landings = []
            }
        }
        .onChange(of: selectedFlight) {
            if selectedFlight == nil {
                role = .pm
            }
        }
        .onChange(of: flights) {
            print("\(flights.count) flights loaded...")
        }
    }
}

#Preview {
    NewFlightView()
}


struct flightAwareDetailView: View {
    @Binding var selectedFlight: FlightAwareFlight?
    
    var body: some View {
        if let newFlight = selectedFlight {
            HStack {
                HStack(alignment: .center) {
                    let imageName: String = "Logo/\(newFlight.operatorIcao ?? "")"
                    if imageExists(named: imageName) {
                        Image(imageName)
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    VStack(alignment: .leading) {
                        Text("\(newFlight.ident) • \(Date.now.formatted(date: .abbreviated, time: .omitted))").foregroundStyle(.secondary).font(.caption)
                        Text("\(newFlight.origin?.code ?? "") to \(newFlight.destination?.code ?? "")").font(.title)
                    }
                }
                Spacer()
                Button { selectedFlight = nil } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(5)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            }
            VStack(alignment: .leading) {
                tolRow(airport: newFlight.origin?.dataAirport,
                       scheduled1: newFlight.scheduledOut,
                       actual1: newFlight.actualOut,
                       scheduled2: newFlight.scheduledOff,
                       actual2: newFlight.actualOff,
                       depart: true)
                HStack {
                    VStack { Divider() }
                }
                tolRow(airport: newFlight.destination?.dataAirport,
                       scheduled1: newFlight.scheduledOn,
                       actual1: newFlight.actualOn,
                       scheduled2: newFlight.scheduledIn,
                       actual2: newFlight.actualIn,
                       depart: false)
            }
        }
    }
}
