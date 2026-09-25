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
    @Binding var selectedFlight: Flight?
    @Binding var selectedAirport: Airport?
    @Binding var selectedAircraft: Aircraft?
    @Binding var overlayHeight: CGFloat
    
    private let defaultCamera = MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 39.8, longitude: -104.7),
            distance: 50000000)
    
    var body: some View {
        Map(position: $position) {
            if let flight = selectedFlight {
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
            if let airport = selectedAirport {
                ForEach(airport.allFlights) { flight in
                    if let route = flight.simpleRoute {
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
            if let aircraft = selectedAircraft {
                ForEach(aircraft.flights ?? []) { flight in
                    if let route = flight.simpleRoute {
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
            .onChange(of: selectedFlight) {
                if selectedFlight == nil { withAnimation(.easeInOut(duration: 2.0)) { position = .camera(defaultCamera) }
                } else { withAnimation(.easeInOut(duration: 2.0)) { position = .automatic } }
            }
            .onChange(of: selectedAirport) {
                if selectedAirport == nil { withAnimation(.easeInOut(duration: 2.0)) { position = .camera(defaultCamera) }
                } else { withAnimation(.easeInOut(duration: 2.0)) { position = .automatic } }
            }
            .onChange(of: selectedAircraft) {
                if selectedAircraft == nil { withAnimation(.easeInOut(duration: 2.0)) { position = .camera(defaultCamera) }
                } else { withAnimation(.easeInOut(duration: 2.0)) { position = .automatic } }
            }
    }
}

/*#Preview {
    RecordMapView()
}
*/
