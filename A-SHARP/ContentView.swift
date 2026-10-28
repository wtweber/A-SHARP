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
    
    //@State var overlaySize: CGSize = .zero
    @State var overlayHeight: CGFloat = .zero
    
    @State var selectedFlight: Flight?
    @State var selectedAirport: Airport?
    @State var selectedAircraft: Aircraft?
    @State var selectedItem: SelectedItem?
    
    @State var navigationPath: [SelectedItem] = []
    
    @State private var showMenu: Bool = false
    
    var body: some View {
        RecordMapView(navigationPath: $navigationPath, selectedAirport: $selectedAirport, selectedAircraft: $selectedAircraft, overlayHeight: overlayHeight)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    showMenu.toggle()
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(5)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .padding()
            }
            .overlay(alignment: .bottomLeading) {
                VStack {
                    NavigationTabView(navigationPath: $navigationPath, selectedItem: $selectedItem, selectedAirport: $selectedAirport, selectedAircraft: $selectedAircraft)//, overlayHeight: $overlayHeight)
                        .clipShape(.rect(cornerRadius: 36))
                        .padding([.horizontal], max(15 * (1 - overlayHeight/windowSize.height), 0))
                        .ignoresSafeArea(edges: .bottom)
                }
                .frame(maxWidth: horizontalClass == .compact ? .infinity : 375, maxHeight: overlayHeight)
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
                //.resizableOverlay(size: $overlaySize)
            }
            .ignoresSafeArea(edges: .leading)
            .onAppear {
                overlayHeight = horizontalClass == .compact ? windowSize.height * 0.3 : .infinity
            }
            .sheet(isPresented: $showMenu) {
                EmptyView()
            }
            .onChange(of: selectedItem) {
                print(selectedItem)
            }
            
        
    }
}

#Preview {
    ContentView()
}
