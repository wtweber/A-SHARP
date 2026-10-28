//
//  AircraftListView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import SwiftData

struct AircraftListView: View {
    @Environment(\.windowSize) private var windowSize
    
    @Query(sort: \Aircraft.registration, sectionBy: \.icaoCode)
    var aircrafts: SectionedResults<Aircraft, String>
    
    @Binding var navigationPath: [SelectedItem]
    @Binding var searchText: String
    
    init(navigationPath: Binding<[SelectedItem]>, searchText: Binding<String>) {
        _navigationPath = navigationPath
        _searchText = searchText
        
        let queryText = searchText.wrappedValue
        _aircrafts = Query(filter: #Predicate {
            if queryText.isEmpty { return true }
            else {
                return $0.registration?.contains(queryText) ?? false
            }
        }, sort: \Aircraft.registration, sectionBy: \.icaoCode)
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Aircraft")
                    .font(.system(size: 34, weight: .bold, design: .default))
                Spacer()
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
            .padding([.horizontal])
            searchBarView(searchText: $searchText)
                List(aircrafts) { section in
                    Section(section.title) {
                        ForEach(section) { aircraft in
                            NavigationLink(value: SelectedItem.aircraft(item: aircraft)) {
                                AircraftRowView(aircraft: aircraft, operatorString: aircraft.flights?.first?.operatorString)
                            }
                            /*NavigationLink {
                                AircraftDetailView(aircraft: aircraft)
                                    .onDisappear {
                                        selectedAircraft = nil
                                    }
                            } label: {
                                AircraftRowView(aircraft: aircraft, operatorString: aircraft.flights?.first?.operatorString)
                            }.tag(aircraft)*/
                            .listRowBackground(Color.viewBackground)
                        }
                    }
                }
                .navigationDestination(for: SelectedItem.self) { item in
                    if case .aircraft(let aircraft) = item {
                        AircraftDetailView(aircraft: aircraft).onDisappear { navigationPath = [] }
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
                .scrollContentBackground(.hidden)
                .background(Color.viewBackground)
                .listStyle(.inset)
            }.background(Color.viewBackground)
        }
    }
}

