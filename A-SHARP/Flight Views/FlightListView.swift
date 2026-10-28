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
    
    @State var showNewSheet: Bool = false
    @Binding var navigationPath: [SelectedItem]
    
    //@Binding var selectedFlight: Flight?    //@Binding var overlayHeight: CGSize
    //@Binding var selectedItem: SelectedItem?
    
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
                        /*FlightDetailView(flight: flight)
                            .onDisappear { selectedItem = nil }
                            //.onAppear { selectedItem = SelectedItem.flight(flight: flight) }
                    } label: { FlightRowView(flight: flight) }
                    .tag(SelectedItem.flight(flight: flight))*/
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
            /*.onChange(of: selectedItem) { _, newItem in
                if newItem == nil {
                    print("Reset view")
                    //navigationPath.removeLast()
                }
            }*/
            .onChange(of: navigationPath) { oldPath, newPath in
                print("\(oldPath) - \(newPath)")
            }
        }
    }
}

/*
 FlightDetailView(flight: flight)
 .onDisappear { selectedFlight = nil }
 } label:
 */
