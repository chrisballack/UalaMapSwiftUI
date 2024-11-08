//
//  MapView.swift
//  UalaMap
//
//  Created by Christians Bonilla on 4/11/24.
//

import SwiftUI
import MapKit

/// Scren to show a map and shpw the cities location
struct MapView: View {
    
    @Binding var location: Location?
    @State private var position: MapCameraPosition
    
    init(location: Binding<Location?>) {
        self._location = location
        
        let initialLocation = location.wrappedValue
        if let location = initialLocation {
            self._position = State(initialValue: MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: location.coord.lat, longitude: location.coord.lon),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            ))
        } else {
            self._position = State(initialValue: MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 8.0, longitude: -72.0),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            ))
        }
    }
    
    /// Determinate the region where the map will move and some optional chaining to avoid errors
    var body: some View {
        
        let region = location.flatMap {
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coord.lat, longitude: $0.coord.lon),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
        
        if let region = region {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 3.0)) {
                    
                    self.position = .region(region)
                    
                }
            }
        }
        
        return Group {
            if let location = location {
                Map(position: $position) {
                    Marker("", coordinate: CLLocationCoordinate2D(
                                        latitude: location.coord.lat,
                                        longitude: location.coord.lon))
                    
                }
                .accessibilityIdentifier("MapViewMap")
                .navigationTitle("\(location.name), \(location.country)")
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.all)
            } else {
                HStack{
                    Spacer()
                    Text(String(localized: "NoCitiesMap"))
                        .accessibilityIdentifier("NoCitiesMessage")
                    Spacer()
                }
                
            }
        }
    }
}

#Preview {
    MapView(location: .constant(Location(country: "hola", name: "mundo", id: 1, coord: Coordinate(lon: -72, lat: 2.2), favorite: false)))
}
