//
//  AircraftSearchWrapper.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI

struct AircraftSearchWrapper: View {
    @Binding var navigationPath: [SelectedItem]
    @Binding var selectedAircraft: Aircraft?
    @State var searchText: String = ""
    
    var body: some View {
        AircraftListView(navigationPath: $navigationPath, searchText: $searchText)
    }
}
