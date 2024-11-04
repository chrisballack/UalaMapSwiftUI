//
//  ContentView.swift
//  UalaMap
//
//  Created by Christians Bonilla on 1/11/24.
//

import SwiftUI

protocol DataLoader {
    func loadCities()
    func favButtonTapped(_ location: Location)
}

struct ListView: View, DataLoader {

    @State private var searchText: String = ""
    @State private var filterActive: Bool = false
    @State private var cities: [Location] = []
    @State private var favCities: [Location] = []
    @State private var isLoading: Bool = false
    let SQLManagers = SQLManager()
    
    private var cityListView: some View {
        @ViewBuilder
        var content: some View {
            let citiesToDisplay = filterActive ? favCities : cities
            
            if citiesToDisplay.isEmpty {
                Text(filterActive ? "No favorites found" : "No cities found")
            } else {
                ForEach(citiesToDisplay, id: \.self) { item in
                    CityRow(item: item, buttonAction: {
                        favButtonTapped(item)
                    })
                }
            }
        }
        
        return content
    }

    var body: some View {
        NavigationStack {
            VStack {
                FilterComponent(textInput: $searchText, byFavorites: $filterActive)
                if isLoading {
                    ProgressView(String(localized: "loadingCities"))
                } else {
                    ScrollView {
                        Spacer(minLength: 16)
                        LazyVStack {
                            cityListView
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
               
                if cities.isEmpty { loadCities() }
                if favCities.isEmpty {
                    favCities = SQLManagers.fetchAllFavorites()
                }
            }
        }
    }
    
    internal func favButtonTapped(_ location: Location) {
        if let index = cities.firstIndex(where: { $0.id == location.id }) {
            cities[index].Favorite.toggle()
            
            if cities[index].Favorite {
                favCities.append(cities[index])
            } else {
                if let favIndex = favCities.firstIndex(where: { $0.id == location.id }) {
                    favCities.remove(at: favIndex)
                }
            }
            
            DispatchQueue.global(qos: .background).async {
                if cities[index].Favorite {
                    SQLManagers.insertFavorites(location: cities[index])
                } else {
                    SQLManagers.deleteFavorite(by: cities[index].id)
                }
            }
        }
    }

    internal func loadCities() {
        isLoading = true
        let jsonManager = JSONManager(sqlManager: SQLManagers)
        jsonManager.loadJSON { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loadedCities):
                    self.cities = loadedCities
                    self.isLoading = false  // Set isLoading to false after loading
                case .failure(let error):
                    print("Error on JSON", error)
                    self.isLoading = false  // Set isLoading to false on error
                }
            }
        }
    }
}

#Preview {
    ListView()
}


