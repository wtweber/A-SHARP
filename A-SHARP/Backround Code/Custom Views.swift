//
//  Custom Views.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import Foundation
import SwiftUI

struct TimeDivider: View {
    var time: Double?
    var body: some View {
        ZStack(alignment: .center) {
            Divider()
            if let time {
                let duration: Duration = .seconds(time * 3600.0) // 5 minutes
                Text(duration, format: .time(pattern: .hourMinute))
                    .padding(.horizontal, 5)
                    .background(.background)
            }
            
        }
    }
}

struct DoubleRow: View {
    @State var title: String
    @State var value: Double?
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if let value {
                Text(value, format: .number.precision(.fractionLength(1)))
            }
        }
    }
}

struct IntRow: View {
    @State var title: String
    @State var value: Int?
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if let value {
                Text(value, format: .number)
            }
        }
    }
}

struct AircraftImageView: View {
    @State var image: Image?
    @State var operatorString: String?
    
    var body: some View {
        if let image {
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(CompanyColor(rawValue: operatorString ?? "")?.color ?? Color.accentColor, lineWidth: 5))
        } 
    }
}
