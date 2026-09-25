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
    
    @Binding var selectedAircraft: Aircraft?
    @Binding var searchText: String
    @Binding var overlayHeight: CGFloat
    
    init(selectedAircraft: Binding<Aircraft?>, searchText: Binding<String>, overlayHeight: Binding<CGFloat>) {
        _selectedAircraft = selectedAircraft
        _searchText = searchText
        _overlayHeight = overlayHeight
        
        let queryText = searchText.wrappedValue
        _aircrafts = Query(filter: #Predicate {
            if queryText.isEmpty { return true }
            else {
                return $0.registration?.contains(queryText) ?? false
            }
        }, sort: \Aircraft.registration, sectionBy: \.icaoCode)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Aircraft")
                Spacer()
            }.font(.system(size: 34, weight: .bold, design: .default))
                .padding([.horizontal, .top])
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
            NavigationStack {
                List(aircrafts, selection: $selectedAircraft) { section in
                    Section(section.title) {
                        ForEach(section) { aircraft in
                            NavigationLink {
                                AircraftDetailView(aircraft: aircraft, overlayHeight: $overlayHeight)
                                    .onDisappear {
                                        selectedAircraft = nil
                                    }
                            } label: {
                                AircraftRowView(aircraft: aircraft, operatorString: aircraft.flights?.first?.operatorString)
                            }.tag(aircraft)
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

