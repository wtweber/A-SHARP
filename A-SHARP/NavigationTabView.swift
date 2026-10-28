//
//  NavigationTabView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct NavigationTabView: View {
    @Binding var navigationPath: [SelectedItem]
    
    @Binding var selectedItem: SelectedItem?
    //@Binding var selectedFlight: Flight?
    @Binding var selectedAirport: Airport?
    @Binding var selectedAircraft: Aircraft?
    //@Binding var overlayHeight: CGFloat
    //@Binding var overlaySize: CGSize
    @State var searchText: String = ""
    
    var body: some View {
        TabView {
            Tab("Flights", systemImage: "airplane.ticket") {
                FlightListView(navigationPath: $navigationPath) //selectedItem: $selectedItem)//, overlayHeight: $overlaySize)
                }
            Tab("Airports", image: "airport.large") {
                AirportSearchWrapper(selectedAirport: $selectedAirport)
            }
            Tab("Aircraft", systemImage: "airplane.landed") {
                AircraftSearchWrapper(selectedAircraft: $selectedAircraft)
                }
            /*Tab("Crew", systemImage: "person.3") {
                NavigationStack { EmptyView() }
                }
            Tab("Stats", systemImage: "chart.pie", role: .search) {
                StatsView(overlayHeight: $overlayHeight)
            }*/
        }.environment(\.horizontalSizeClass, .compact)
    }
}
