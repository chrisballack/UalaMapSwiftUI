//
//  CitiesViewModel 2.swift
//  UalaMap
//
//  Created by Maria Fernanda Paz Rodriguez on 6/11/24.
//


import SwiftUI

/// A `ViewModel` responsible for managing and processing city data for display in a SwiftUI view.
class CitiesViewModel: ObservableObject {
    
    /// The list of all cities.
    @Published var cities: [Location] = []
    
    /// The list of favorite cities.
    @Published var favCities: [Location] = []
    
    /// The list of cities that match the search text or are filtered based on the active filter.
    @Published var filteredCities: [Location] = []
    
    /// The text entered in the search field for filtering cities.
    @Published var searchText: String = ""
    
    /// A flag indicating whether the cities data is currently being loaded.
    @Published var isLoading: Bool = false
    
    /// A flag to determine if a filter is currently active (i.e., showing only favorite cities).
    @Published var filterActive: Bool = false
    
    /// The currently selected city.
    @Published var selectedItem: Location?
    
    /// The currently selected to show information in the modal
    @Published var infoItem: Location?
    
    private let _SQLManager: SQLManager
    
    /// Initializes the `CitiesViewModel` with an optional `SQLManager` to handle favorite cities storage.
    init(SQLManager: SQLManager = SQLManager()) {
        self._SQLManager = SQLManager
    }
    
    /// Fetches the list of cities from a remote JSON file and updates the `cities` and `favCities` arrays.
    func fetchCities() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let url = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            do {
                let decodedCities = try JSONDecoder().decode([Location].self, from: data)
                
                await fetchFavCities()
                
                // Mark cities as favorites if they exist in the `favCities` list
                let updatedCities = decodedCities.map { city -> Location in
                    var city = city
                    if self.favCities.contains(where: { $0.id == city.id }) {
                        city.Favorite = true
                    }
                    return city
                }
                
                // Sort the cities alphabetically by name
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
    
    /// Fetches the list of favorite cities from the local database using the `_SQLManager`.
    func fetchFavCities() async {
        DispatchQueue.main.async {
            self.favCities = self._SQLManager.fetchAllFavorites()
        }
    }
    
    /// Filters the cities based on the `searchText` and whether the `filterActive` flag is set.
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
    
    /// Toggles the favorite status of a city and updates both the `favCities` array and the local database.
    func changeFavorites(for location: Location) {
        if let index = cities.firstIndex(where: { $0.id == location.id }) {
            // Toggle the Favorite status
            cities[index].Favorite.toggle()
            
            if cities[index].Favorite {
                favCities.append(cities[index])
            } else {
                favCities.removeAll { $0.id == location.id }
            }
            
            // Update the local database based on the favorite status
            if cities[index].Favorite {
                _SQLManager.insertFavorites(location: cities[index])
            } else {
                _SQLManager.deleteFavorite(by: cities[index].id)
            }
            
            // Apply filtering after updating favorites
            Task {
                await filterCities()
            }
        }
    }
}
