//
//  AirportSearchWrapper.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI

struct AirportSearchWrapper: View {
    @Binding var navigationPath: [SelectedItem]
    @Binding var selectedAirport: Airport?
    @State var searchText: String = ""
    
    var body: some View {
        AirportListView(navigationPath: $navigationPath, searchText: $searchText)
    }
}

