//
//  NavTestView.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI
import SwiftData

struct NavTestView: View {
    //@State private var selection: Flight?
    @Binding var path: [SelectedItem]
    
    @Query(sort: \Flight.actualOut, order: .reverse)
    var flights: [Flight]
    
    var body: some View {
        NavigationStack(path: $path) {
            List(flights) { item in
                NavigationLink(value: SelectedItem.flight(flight: item)) {
                    Text(item.ident ?? "")
                }
            }
            .navigationDestination(for: SelectedItem.self) { item in
                if case .flight(let flight) = item {
                    TestDetailView(flight: flight).onDisappear { path = [] }
                }
                //FlightDetailView(flight: item)//.onDisappear { path.removeAll() }
            }
        }.onChange(of: path) {
            print(path)
        }
    }
}

