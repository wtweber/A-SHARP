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
    
    @Binding var selectedFlight: Flight?    //@Binding var overlayHeight: CGSize
    
    var body: some View {
        NavigationStack {
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
                List(flights, id: \.self, selection: $selectedFlight) { flight in
                    NavigationLink {
                        FlightDetailView(flight: flight)//, overlayHeight: $overlayHeight)
                            .onDisappear {
                                selectedFlight = nil
                            }
                    } label: {
                        FlightRowView(flight: flight)
                    }.id(flight).listRowBackground(Color.viewBackground)
                }
                .scrollContentBackground(.hidden)
                .background(Color.viewBackground)
                .listStyle(.inset)
                
            }.toolbar(.hidden, for: .navigationBar)
                .sheet(isPresented: $showNewSheet) {
                    EmptyView()
                }
        }
    }
}

