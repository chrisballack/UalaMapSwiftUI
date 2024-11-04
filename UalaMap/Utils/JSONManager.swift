//
//  JSONManager.swift
//  UalaMap
//
//  Created by Christians Bonilla on 3/11/24.
//

import Foundation


protocol JSONManagers {
    func loadJSON(completion: @escaping (Result<[Location], Error>) -> Void)
}

class JSONManager: JSONManagers {
    
    let sqlManager: SQLManager
    
        init(sqlManager: SQLManager) {
            self.sqlManager = sqlManager
        }
    
    func loadJSON(completion: @escaping (Result<[Location], Error>) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "Cities", withExtension: "json") else {
            let error = NSError(domain: "JSONManagerError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to locate Cities.json in bundle."])
            completion(.failure(error))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                let data = try Data(contentsOf: url)
                var locations = try JSONDecoder().decode([Location].self, from: data)
                
                for index in locations.indices {
                                 let isFavorite = self.sqlManager.favoriteExists(by: locations[index].id)
                                 locations[index].Favorite = isFavorite // Update Favorite property
                             }
                
                DispatchQueue.main.async {
                    completion(.success(locations.sorted(by: { $0.name < $1.name})))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
