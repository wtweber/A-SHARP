//
//  AircraftSearchWrapper.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI

struct AircraftSearchWrapper: View {
    @Binding var selectedAircraft: Aircraft?
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack { AircraftListView(selectedAircraft: $selectedAircraft, searchText: $searchText) }
    }
}
