//
//  ContentView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalClass
    @Environment(\.windowSize) private var windowSize
    
    @State var overlayHeight: CGFloat = .zero
    @State var selectedFlight: Flight?
    @State var selectedAirport: Airport?
    @State var selectedAircraft: Aircraft?
    
    @State private var showMenu: Bool = false
    
    var body: some View {
        RecordMapView(selectedFlight: $selectedFlight, selectedAirport: $selectedAirport, selectedAircraft: $selectedAircraft, overlayHeight: $overlayHeight)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    showMenu.toggle()
                }) {
                    Label("Settings", systemImage: "line.3.horizontal")
                                            .labelStyle(.iconOnly)
                                            .foregroundStyle(.primary)
                                            .padding()
                                            .background(.ultraThinMaterial)
                                            .clipShape(.circle)
                }.padding().buttonStyle(.plain)
            }
            .overlay(alignment: .bottomLeading) {
                VStack {
                    NavigationTabView(selectedFlight: $selectedFlight, selectedAirport: $selectedAirport, selectedAircraft: $selectedAircraft, overlayHeight: $overlayHeight)
                        .clipShape(.rect(cornerRadius: 36))
                        .padding([.horizontal])
                        .ignoresSafeArea(edges: .bottom)
                }
                .frame(maxWidth: horizontalClass == .compact ? .infinity : 375, maxHeight: overlayHeight)
            }
            .ignoresSafeArea(edges: .leading)
            .onAppear {
                overlayHeight = horizontalClass == .compact ? windowSize.height * 0.3 : .infinity
            }
            .sheet(isPresented: $showMenu) {
                EmptyView()
            }
            
        
    }
}

#Preview {
    ContentView()
}
