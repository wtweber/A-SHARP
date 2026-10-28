//
//  AirportListView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import SwiftData


struct AirportListView: View {
    @Environment(\.windowSize) private var windowSize
    
    @Query(sort: \Airport.icao, sectionBy: \.isoCountryCode)
    var airports: SectionedResults<Airport, String>
    
    @Binding var navigationPath: [SelectedItem]
    
    //@Binding var selectedAirport: Airport?
    @Binding var searchText: String
    //@Binding var overlayHeight: CGFloat
    
    //@State private var isEditing = false
    
    init(navigationPath: Binding<[SelectedItem]>, searchText: Binding<String>) {//}, overlayHeight: Binding<CGFloat>) {
        //_selectedAirport = selectedAirport
        _navigationPath = navigationPath
        _searchText = searchText
        //_overlayHeight = overlayHeight
        
        let queryText = searchText.wrappedValue
        _airports = Query(filter: #Predicate {
            if queryText.isEmpty { return true }
            else {
                return $0.name?.localizedStandardContains(queryText) ?? false ||
                $0.icao?.localizedStandardContains(queryText) ?? false ||
                $0.iata?.localizedStandardContains(queryText) ?? false ||
                $0.gpsCode?.localizedStandardContains(queryText) ?? false //||
                //$0.localCode?.localizedStandardContains(queryText) ?? false
                
            }
        }, sort: \Airport.icao, sectionBy: \.isoCountryCode)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Text("Airports")
                    .font(.system(size: 34, weight: .bold, design: .default))
                Spacer()
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
            .padding([.horizontal])
            searchBarView(searchText: $searchText)
            NavigationStack(path: $navigationPath) {
                List(airports) { section in
                    Section(Locale.current.localizedString(forRegionCode: section.title) ?? "Unknown") {
                        ForEach(section) { airport in
                            /*NavigationLink {
                                AirportDetailView(airport: airport)//, overlayHeight: $overlayHeight)
                                    .onDisappear {
                                        selectedAirport = nil
                                    }
                            } label: {
                                AirportRowView(airport: airport)
                            }.tag(airport)*/
                            NavigationLink(value: SelectedItem.airport(item: airport)) {
                                AirportRowView(airport: airport)
                            }
                             .listRowBackground(Color.viewBackground)
                        }
                    }
                }
                .navigationDestination(for: SelectedItem.self) { item in
                    if case .airport(let airport) = item {
                        AirportDetailView(airport: airport).onDisappear { navigationPath = [] }
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
                .scrollContentBackground(.hidden)
                .background(Color.viewBackground)
                .listStyle(.inset)
            }
        }.background(Color.viewBackground)
    }
}
