//
//  AirportSearchWrapper.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI

struct AirportSearchWrapper: View {
    @Binding var selectedAirport: Airport?
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack { AirportListView(selectedAirport: $selectedAirport, searchText: $searchText) }
    }
}

