//
//  EmptyView.swift
//  A-SHARP
//
//  Created by William Weber on 1/27/26.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack {
            HStack {
                ForEach(AirportType.allCases) { airport in
                    airport.annotationImage.font(.largeTitle)
                        .symbolRenderingMode(.multicolor)
                }
            }
            Text("Still Working...").font(.largeTitle)
        }
    }
}

#Preview {
    EmptyView()
}
