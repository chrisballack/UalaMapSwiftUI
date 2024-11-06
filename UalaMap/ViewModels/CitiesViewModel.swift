//
//  CitiesViewModel 2.swift
//  UalaMap
//
//  Created by Maria Fernanda Paz Rodriguez on 6/11/24.
//


import SwiftUI

class CitiesViewModel: ObservableObject {
    
    @Published var cities: [Location] = []
    @Published var favCities: [Location] = []
    @Published var filteredCities: [Location] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var filterActive: Bool = false
    @Published var selectedItem: Location?
    
    private let _SQLManager: SQLManager
    
    init(SQLManager: SQLManager = SQLManager()) {
        self._SQLManager = SQLManager
    }
    
    func fetchCities() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let url = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            do {
                let decodedCities = try JSONDecoder().decode([Location].self, from: data)
                
                let sqlManager = SQLManager()
                let favoriteLocations = sqlManager.fetchAllFavorites()
                
                let updatedCities = decodedCities.map { city -> Location in
                    var city = city
                    if favoriteLocations.contains(where: { $0.id == city.id }) {
                        city.Favorite = true
                    }
                    return city
                }
                
                let sortedCities = updatedCities.sorted { $0.name < $1.name }
                DispatchQueue.main.async {
                    self.cities = sortedCities
                    Task {
                        await self.filterCities()
                    }
                }
               
            } catch {
                print("Error al decodificar las ciudades: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        } catch {
            print("Error al cargar ciudades: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    
    
    func fetchFavCities() async {
        DispatchQueue.main.async {
            self.favCities = self._SQLManager.fetchAllFavorites()
        }
    }
    
    func filterCities() async {
        let citiesToFilter = filterActive ? favCities : cities
        
        let filtered = citiesToFilter.filter { city in
            searchText.isEmpty || city.name.localizedCaseInsensitiveContains(searchText)
        }
        DispatchQueue.main.async {
            self.filteredCities = filtered
            self.isLoading = false
        }
        
    }
    
    func changeFavorites(for location: Location) {
        if let index = cities.firstIndex(where: { $0.id == location.id }) {
            cities[index].Favorite.toggle()
            
            if cities[index].Favorite {
                favCities.append(cities[index])
            } else {
                favCities.removeAll { $0.id == location.id }
            }
            
            if cities[index].Favorite {
                _SQLManager.insertFavorites(location: cities[index])
            } else {
                _SQLManager.deleteFavorite(by: cities[index].id)
            }
            
            Task {
                await filterCities()
            }
        }
    }
}
