//
//  CitiesModel.swift
//  UalaMap
//
//  Created by Maria Fernanda Paz Rodriguez on 3/11/24.
//

import Foundation

struct Coordinate: Codable,Hashable {
    let lon: Double
    let lat: Double
}

struct Location: Codable,Hashable {
    let country: String
    let name: String
    let id: Int  // Renamed from "_id" to "id" to follow Swift naming conventions
    let coord: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"  // Map the JSON key "_id" to the Swift property "id"
        case coord
    }
}
