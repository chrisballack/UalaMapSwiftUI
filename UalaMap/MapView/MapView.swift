//
//  MapView.swift
//  UalaMap
//
//  Created by Christians Bonilla on 4/11/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    let location: Location
    @State private var position: MapCameraPosition
    
    init(location: Location) {
        self.location = location
        
        self._position = State(initialValue: MapCameraPosition.region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.coord.lat, longitude: location.coord.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )))
        print("self.location",self.location)
    }
    
    var body: some View {
        Map(position: $position) {
            Marker("", coordinate: CLLocationCoordinate2D(
                latitude: location.coord.lat,
                longitude: location.coord.lon))
        }
        .navigationTitle("\(location.name), \(location.country)")
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MapView(location: Location(country: "hola", name: "mundo", id: 1, coord: Coordinate(lon: -72, lat: 2.2), favorite: false))
}
