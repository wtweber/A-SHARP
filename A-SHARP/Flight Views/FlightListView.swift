//
//  FlightListView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import SwiftData

struct FlightListView: View {
    @Environment(\.windowSize) private var windowSize
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Flight.actualOut, order: .reverse)
    var flights: [Flight]
    
    @Binding var selectedFlight: Flight?
    @Binding var overlayHeight: CGFloat
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Flights")
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
                List(flights, id: \.self, selection: $selectedFlight) { flight in
                    NavigationLink {
                        FlightDetailView(flight: flight, overlayHeight: $overlayHeight)
                            .onDisappear {
                                selectedFlight = nil
                            }
                    } label: {
                        FlightRowView(flight: flight)
                    }.id(flight)
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}

