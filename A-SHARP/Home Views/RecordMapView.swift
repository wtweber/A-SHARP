//
//  RecordMapView.swift
//  A-SHARP
//
//  Created by Will Weber on 9/15/26.
//

import SwiftUI
import MapKit

struct RecordMapView: View {
    @Environment(\.horizontalSizeClass) var horizontalClass
    @Environment(\.windowSize) private var windowSize
    
    @State private var position: MapCameraPosition = .automatic
    
    @Binding var navigationPath: [SelectedItem]
    
    @State var overlayHeight: CGFloat
    
    private let defaultCamera = MapCamera(
        centerCoordinate: CLLocationCoordinate2D(latitude: 39.8, longitude: -104.7),
        distance: 50000000)
    
    var body: some View {
        Map(position: $position) {
            if case .flight(let flight) = navigationPath.last {
                if let originLoc = flight.origin?.location {
                    Annotation("Origin", coordinate: originLoc, anchor: .center) {
                        flight.origin?.airportType?.annotationImage
                            .foregroundStyle(.green, .white)
                            .font(.title)
                    }.annotationTitles(.hidden)
                }
                if let destinationLoc = flight.destination?.location {
                    Annotation("Destination", coordinate: destinationLoc, anchor: .center) {
                        flight.destination?.airportType?.annotationImage
                            .foregroundStyle(.red, .white)
                            .font(.title)
                    }.annotationTitles(.hidden)
                }
                if let route = flight.routeLine {
                    MapPolyline(coordinates: route, contourStyle: .geodesic)
                        .stroke(flight.flightType?.color ?? .accentColor, lineWidth: 2)
                }
            }
            if case .airport(let airport) = navigationPath.last {
                ForEach(airport.allFlights) { flight in
                    if let route = flight.routeLine {
                        MapPolyline(coordinates: route, contourStyle: .geodesic)
                            .stroke(flight.flightType?.color ?? .accentColor, lineWidth: 2)
                    }
                    if let loc = flight.origin?.location {
                        Annotation(flight.origin?.ident ?? "", coordinate: loc, anchor: .center) {
                            Image(systemName: "circle.fill")
                            //.foregroundStyle(Color.green)
                                .foregroundStyle(flight.accentColor.mix(with: Color.primary, by: 0.25))
                                .font(.caption2)
                        }
                    }
                    if let loc = flight.destination?.location {
                        Annotation(flight.destination?.ident ?? "", coordinate: loc, anchor: .center) {
                            Image(systemName: "circle.fill")
                            //.foregroundStyle(Color.red)
                                .foregroundStyle(flight.accentColor.mix(with: Color.primary, by: 0.25))
                                .font(.caption2)
                        }
                    }
                }
            }
            if case .aircraft(let aircraft) = navigationPath.last {
                ForEach(aircraft.flights ?? []) { flight in
                    if let route = flight.routeLine {
                        MapPolyline(coordinates: route, contourStyle: .geodesic)
                            .stroke(flight.flightType?.color ?? .accentColor, lineWidth: 2)
                    }
                    if let loc = flight.origin?.location {
                        Annotation(flight.origin?.ident ?? "", coordinate: loc, anchor: .center) {
                            Image(systemName: "circle.fill")
                            //.foregroundStyle(Color.green)
                                .foregroundStyle(flight.accentColor.mix(with: Color.primary, by: 0.25))
                                .font(.caption2)
                        }
                    }
                    if let loc = flight.destination?.location {
                        Annotation(flight.destination?.ident ?? "", coordinate: loc, anchor: .center) {
                            Image(systemName: "circle.fill")
                            //.foregroundStyle(Color.red)
                                .foregroundStyle(flight.accentColor.mix(with: Color.primary, by: 0.25))
                                .font(.caption2)
                        }
                    }
                }
            }
            if case .person(let person) = navigationPath.last {
                ForEach(person.flights ?? []) { flight in
                    if let route = flight.routeLine {
                        MapPolyline(coordinates: route, contourStyle: .geodesic)
                            .stroke(flight.flightType?.color ?? .accentColor, lineWidth: 2)
                    }
                    if let loc = flight.origin?.location {
                        Annotation(flight.origin?.ident ?? "", coordinate: loc, anchor: .center) {
                            Image(systemName: "circle.fill")
                            //.foregroundStyle(Color.green)
                                .foregroundStyle(flight.accentColor.mix(with: Color.primary, by: 0.25))
                                .font(.caption2)
                        }
                    }
                    if let loc = flight.destination?.location {
                        Annotation(flight.destination?.ident ?? "", coordinate: loc, anchor: .center) {
                            Image(systemName: "circle.fill")
                            //.foregroundStyle(Color.red)
                                .foregroundStyle(flight.accentColor.mix(with: Color.primary, by: 0.25))
                                .font(.caption2)
                        }
                    }
                }
            }
        }
        .mapStyle(.hybrid(elevation: .realistic))
        .safeAreaInset(edge: .leading) {
            Color.clear.frame(width: horizontalClass == .compact ? 0 : 375)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: horizontalClass == .compact ? windowSize.height * 0.3 : 0)
        }
        .onChange(of: navigationPath) {
            if navigationPath.isEmpty { withAnimation(.easeInOut(duration: 2.0)) { position = .camera(defaultCamera) }
            } else { withAnimation(.easeInOut(duration: 2.0)) { position = .automatic } }
        }
    }
}
