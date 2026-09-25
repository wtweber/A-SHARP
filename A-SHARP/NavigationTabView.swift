//
//  NavigationTabView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct NavigationTabView: View {
    @Binding var selectedFlight: Flight?
    @Binding var selectedAirport: Airport?
    @Binding var selectedAircraft: Aircraft?
    @Binding var overlayHeight: CGFloat
    @State var searchText: String = ""
    
    var body: some View {
        TabView {
            Tab("Flights", systemImage: "airplane.ticket") {
                FlightListView(selectedFlight: $selectedFlight, overlayHeight: $overlayHeight)
                }
            Tab("Airports", image: "airport.large") {
                NavigationStack { AirportListView(selectedAirport: $selectedAirport, searchText: $searchText, overlayHeight: $overlayHeight) }
                }
            Tab("Aircraft", systemImage: "airplane.landed") {
                NavigationStack { AircraftListView(selectedAircraft: $selectedAircraft, searchText: $searchText, overlayHeight: $overlayHeight) }
                }
            Tab("Crew", systemImage: "person.3") {
                NavigationStack { EmptyView() }
                }
            Tab("Stats", systemImage: "chart.pie", role: .search) {
                StatsView(overlayHeight: $overlayHeight)
            }
        }.environment(\.horizontalSizeClass, .compact)
    }
}
