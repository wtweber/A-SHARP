//
//  DragBarView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct DragBarView: View {
    @Environment(\.windowSize) private var windowSize
    
    @Binding var dragOffset: CGFloat
    
    var body: some View {
        Capsule()
            .fill(Color.gray)
            .frame(width: 50, height: 5)
            .padding(.top, 5)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .global)
                    .onChanged { value in
                        withAnimation(.spring()) {
                            dragOffset =  max(0, windowSize.height - value.location.y + 50)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            let releaseHeight = windowSize.height - value.predictedEndLocation.y
                            if releaseHeight < windowSize.height * 0.3 {
                                dragOffset = windowSize.height * 0.30
                            } else if releaseHeight < windowSize.height * 0.75 {
                                dragOffset = windowSize.height * 0.5
                            } else {
                                dragOffset = .infinity
                            }
                        }
                    }
            )
    }
}

