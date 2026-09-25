//
//  AirportRowView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI

struct AirportRowView: View {
    @State var airport: Airport
    @State var alignment: HorizontalAlignment = .leading
    
    var body: some View {
        VStack(alignment: alignment) {
            HStack {
                if let icon = airport.airportType?.annotationImage {
                    icon.symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                }
                
                Text(airport.ident)
            }.font(.headline)
            if let name = airport.name {
                Text(name)
            }
            Text(airport.locationName ?? "")
        }
    }
}
/*
#Preview {
    AirportRowView()
}
*/
