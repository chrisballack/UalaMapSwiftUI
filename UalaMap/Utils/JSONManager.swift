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
    func loadJSON(completion: @escaping (Result<[Location], Error>) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "Cities", withExtension: "json") else {
            let error = NSError(domain: "JSONManagerError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to locate Cities.json in bundle."])
            completion(.failure(error))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                let data = try Data(contentsOf: url)
                let locations = try JSONDecoder().decode([Location].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(locations))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
