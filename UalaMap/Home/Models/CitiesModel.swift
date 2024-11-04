//
//  CitiesModel.swift
//  UalaMap
//
//  Created by Christians Bonilla on 3/11/24.
//

import Foundation

struct Coordinate: Codable,Hashable {
    let lon: Double
    let lat: Double
}

struct Location: Codable,Hashable,Identifiable {
    let country: String
    let name: String
    let id: Int
    let coord: Coordinate
    var Favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.country = try container.decode(String.self, forKey: .country)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(Int.self, forKey: .id)
        self.coord = try container.decode(Coordinate.self, forKey: .coord)
        self.Favorite = false
    }
    
    init(country: String, name: String, id: Int, coord: Coordinate, favorite: Bool)  {
        self.country = country
        self.name = name
        self.id = id
        self.coord = coord
        self.Favorite = favorite
    }
}
