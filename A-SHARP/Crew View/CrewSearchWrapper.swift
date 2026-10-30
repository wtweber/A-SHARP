//
//  CrewSearchWrapper.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI

struct CrewSearchWrapper: View {
    @Binding var navigationPath: [SelectedItem]
    @State var searchText: String = ""
    
    var body: some View {
        CrewListView(navigationPath: $navigationPath, searchText: $searchText)
    }
}
