//
//  StatsView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.windowSize) private var windowSize
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Flight.actualOut, order: .reverse)
    var flights: [Flight]
    
    @Binding var overlayHeight: CGFloat
    
    @State var selectedYear = "All-Time"
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(selectedYear) Stats").font(.largeTitle)
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
                List {
                    Section {
                        EmptyView()
                    }
                    Section {
                        EmptyView()
                    }
                }.listStyle(.insetGrouped)
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}
