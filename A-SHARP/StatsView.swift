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
                Text("\(filter.title) Stats")
                    .font(.system(size: 34, weight: .bold, design: .default))
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
                    //StatCard(flights: filteredFlights.filter({ $0.flightType == .airline }), type: .airline)
                    //StatCard(flights: filteredFlights.filter({ $0.flightType == .military }), type: .military)
                    //StatCard(flights: filteredFlights.filter({ $0.flightType == .generalAviation }), type: .generalAviation)
                    DistanceCard(flights: filteredFlights)
                    Divider().padding(.vertical)
                    TimeCard(flights: filteredFlights)
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
            //Divider()
            Text("Flight Distance").font(.headline)
            Text("\(totDistance.formatted(.number.precision(.fractionLength(0)))) mi").font(.largeTitle)
            Text("Average distance: \((totDistance / Double(flights.count)).formatted(.number.precision(.fractionLength(0)))) mi").font(.caption)
            LapBar(times: totDistance / 24901.0, iconName: "globe.americas.fill", text: "Around Earth").padding(.vertical)
            LapBar(times: totDistance / 238855.0, iconName: "moon.fill", text: "To the Moon").padding(.vertical)
            LapBar(times: totDistance / 2720000.0, iconName: "sun.max", text: "Around the Sun").padding(.vertical)
            Divider().padding(.top)
            let sorted = flights.sorted(by: { $0.distance ?? 0.0 > $1.distance ?? 0.0 }).filter({ $0.distance != nil })
            if let shortest = sorted.filter({ $0.distance != 0.0 }).last, let longest = sorted.first {
                let flightsByDist = flights.sorted(by: { $0.distance ?? 0.0 > $1.distance ?? 0.0 })
                Text("Longest flight").font(.caption)
                Text("\((longest.distance ?? 0.0).formatted(.number.precision(.fractionLength(0)))) mi").font(.headline)
                FlightRowView(flight: flightsByDist.first!)
                Divider()
                Text("Shortest flight").font(.caption)
                Text("\((shortest.distance ?? 0.0).formatted(.number.precision(.fractionLength(0)))) mi").font(.headline)
                FlightRowView(flight: flightsByDist.filter({ $0.distance != 0.0 }).last!)
            }
            
            
            
        }
    }
}

struct TimeCard: View {
    let flights: [Flight]
    
    var body: some View {
        let totTime: Duration = .seconds(3600.0 * flights.compactMap({$0.totalTime}).reduce(0.0, +))
        VStack(alignment: .leading) {
            //Divider()
            Text("Flight Time").font(.headline)
            Text(totTime.formatted(.units(width: .abbreviated, maximumUnitCount: 2))).font(.largeTitle)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Days").font(.caption)
                        Spacer()
                    }
                    Text("\(totTime.days.formatted(.number.precision(.fractionLength(1))))").font(.headline)
                    Text("Months").font(.caption)
                    Text("\(totTime.months.formatted(.number.precision(.fractionLength(1))))").font(.headline)
                    Text("Avg. Flight Time").font(.caption)
                    Text((totTime.divided(by: flights.count)).formatted(.units(width: .abbreviated, maximumUnitCount: 2))).font(.headline)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("Weeks").font(.caption)
                        Spacer()
                    }
                    Text("\(totTime.weeks.formatted(.number.precision(.fractionLength(1))))").font(.headline)
                    Text("Years").font(.caption)
                    Text("\(totTime.years.formatted(.number.precision(.fractionLength(2))))").font(.headline)
                    Text(" ").font(.caption)
                    Text(" ").font(.headline)
                }
            }
            Divider()
            let sorted = flights.sorted(by: { $0.totalTime ?? 0.0 > $1.totalTime ?? 0.0 })
            if let shortest = sorted.last, let longest = sorted.first {
                Text("Longest flight").font(.caption)
                FlightRowView(flight: longest)
                Divider()
                Text("Shortest flight").font(.caption)
                FlightRowView(flight: shortest)
            }
        }
    }
}

struct LapBar: View {
    let times: Double
    let iconName: String
    let text: String
    var precision: Int = 1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if times > 1 {
                    Capsule()
                        .frame(width: geometry.size.width)
                        .foregroundStyle(.accent.opacity(0.5))
                }
                Capsule()
                    .frame(width: max(times.truncatingRemainder(dividingBy: 1) * geometry.size.width, 50))
                    .foregroundStyle(.accent)
                /*Spacer()
                    .frame(width: times.remainder(dividingBy: 1) * geometry.size.width)
                    .background(.accent, in: Capsule())*/
                HStack {
                    Image(systemName: iconName).font(.title)
                    Spacer()
                    Text("\(times.formatted(.number.precision(.fractionLength(precision))))x \(text)")
                        
                }.padding(.vertical, 2)
                    .padding(.horizontal, 5)
                
                
            }
        }
        
    }
}
