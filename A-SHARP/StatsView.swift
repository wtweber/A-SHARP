//
//  StatsView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import SwiftData
import Algorithms

struct StatsView: View {
    
    @Query(sort: \Flight.actualOut, order: .reverse)
    var flights: [Flight]
    
    @Binding var navigationPath: [SelectedItem]
    
    @State var filter: FlightFilter = .year(year: Calendar.current.component(.year, from: Date()))
    @State var filteredFlights: [Flight] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("\(filter.title) Stats").font(.largeTitle)
                Spacer()
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
            .padding([.horizontal])
            ScrollView(.horizontal) {
                HStack {
                    Button { filter = .alltime
                    } label: { Text("All Time") }
                        .buttonStyle(SelectedFilterStyle(isSelected: filter == .alltime))
                    ForEach(Array(flights.map({$0.year}).uniqued()), id: \.self) { year in
                        Button { filter = .year(year: year)
                        } label: { Text(year, format: .number.grouping(.never))}
                            .buttonStyle(SelectedFilterStyle(isSelected: filter == .year(year: year)))
                    }
                }
                
            }.padding(.vertical)
            ScrollView(.vertical) {
                VStack {
                    StatCard(flights: filteredFlights.filter({ $0.flightType == .airline }), type: .airline)
                    StatCard(flights: filteredFlights.filter({ $0.flightType == .military }), type: .military)
                    StatCard(flights: filteredFlights.filter({ $0.flightType == .generalAviation }), type: .generalAviation)
                    DistanceCard(flights: filteredFlights)
                }.padding()
            }
            .scrollContentBackground(.hidden)
            .background(Color.viewBackground)
            .listStyle(.inset)
        }.background(Color.viewBackground)
        //.toolbar(.hidden, for: .navigationBar)
        .onChange(of: filter, initial: true) {
            switch filter {
            case .alltime: filteredFlights = flights
            case .year(let year): filteredFlights = flights.filter({ Calendar.current.component(.year, from: $0.date) == year })
            default: filteredFlights = []
            }
        }
        .onChange(of: filteredFlights) {
            navigationPath = [SelectedItem.stats(item: filteredFlights)]
        }
        .onDisappear {
            navigationPath = []
        }
    }
}

struct StatCard: View {
    let flights: [Flight]
    @State var type: FlightType
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(type.name).font(.largeTitle)
                Spacer()
            }
            Text("\(flights.count) flights").font(.headline)
            Text("\(flights.compactMap({$0.totalTime}).reduce(0.0, +).formatted(.number.precision(.fractionLength(1)))) hours")
        }.padding()
        .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.secondary, lineWidth: 2)
            )
        
    }
}

struct DistanceCard: View {
    let flights: [Flight]
    
    var body: some View {
        let totDistance = flights.compactMap({$0.distance}).reduce(0.0, +)
        VStack(alignment: .leading) {
            HStack {
                Text("Flight Distance").font(.headline)
                Spacer()
            }
            Text("\(totDistance.formatted(.number.precision(.fractionLength(0)))) mi").font(.largeTitle)
            Text("Average distance: \((totDistance / Double(flights.count)).formatted(.number.precision(.fractionLength(0)))) mi").font(.caption)
            Label("\((totDistance / 24901.0).formatted(.number.precision(.fractionLength(1))) )x Around Earth", systemImage: "globe.americas.fill")
            Label("\((totDistance / 238855.0).formatted(.number.precision(.fractionLength(1))) )x To the Moon", systemImage: "moon.road.lanes")
            Label("\((totDistance / 2720000.0).formatted(.number.precision(.fractionLength(2))) )x Around the Sun", systemImage: "sun.max")
            Divider()
            if !flights.isEmpty {
                Text("Longest flight").font(.caption)
                FlightRowView(flight: flights.sorted(by: { $0.distance ?? 0.0 > $1.distance ?? 0.0 }).first!)
            }
            
        }
    }
}
