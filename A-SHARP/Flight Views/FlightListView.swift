//
//  FlightListView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import SwiftData



struct FlightListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Flight.actualOut, order: .reverse)
    var flights: [Flight]
    
    @Binding var navigationPath: [SelectedItem]
    @State var showNewSheet: Bool = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                HStack {
                    Text("Flights")
                        .font(.system(size: 34, weight: .bold, design: .default))
                    Spacer()
                    Button { showNewSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(5)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                }
                .padding(.top, 25)
                .padding(.bottom, 5)
                .padding([.horizontal])
                .background(Color.viewBackground)
                List(flights) { flight in
                    NavigationLink(value: SelectedItem.flight(item: flight)) {
                        FlightRowView(flight: flight)
                    }
                    .listRowBackground(Color.viewBackground)
                }
                .navigationDestination(for: SelectedItem.self) { item in
                    if case .flight(let flight) = item {
                        FlightDetailView(flight: flight).onDisappear { navigationPath = [] }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.viewBackground)
                .listStyle(.inset)
            }
            
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showNewSheet) {
                EmptyView()
            }
        }
    }
}
