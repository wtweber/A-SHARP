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
    
    @State var showNewSheet: Bool = false
    
    @Binding var selectedFlight: Flight?
    @Binding var overlayHeight: CGFloat
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    HStack {
                        Spacer()
                        Capsule()
                            .fill(Color.gray)
                            .frame(width: 50, height: 5)
                            .padding(.top, 5)
                            .contentShape(Rectangle())
                        Spacer()
                    }
                    
                    HStack {
                        Text("Flights")
                            .font(.system(size: 34, weight: .bold, design: .default))
                        Spacer()
                        Button { showNewSheet.toggle()
                        } label: {
                            Label("New", systemImage: "plus")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.primary)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(.circle)
                        }.buttonStyle(.plain)
                    }.padding(.top, 25)
                        .padding(.bottom, 5)
                    
                }
                .padding([.horizontal])
                .background(Color(uiColor: .systemGroupedBackground))
                .gesture(
                    DragGesture(minimumDistance: 50, coordinateSpace: .global)
                        .onChanged { value in
                            withAnimation(.snappy) {
                                overlayHeight =  max(0, windowSize.height - value.location.y + 50)
                            }
                        }
                        .onEnded { value in
                            withAnimation(.snappy) {
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
                .sheet(isPresented: $showNewSheet) {
                    EmptyView()
                }
        }
    }
}

