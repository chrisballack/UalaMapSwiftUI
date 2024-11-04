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
    @State private var filteredCities: [Location] = []
    @State private var isNavigating = false
    @State private var selectecItem: Location?

    
    private var cityListView: some View {
        @ViewBuilder
        var content: some View {
            let citiesToDisplay = filteredCities
            
            if citiesToDisplay.isEmpty {
                Text(filterActive ? String(localized: "noFavorites") : String(localized: "noCities"))
            } else {
                ForEach(citiesToDisplay, id: \.self) { item in
                    CityRow(item: item, buttonAction: {
                        favButtonTapped(item)
                    }).onTapGesture {
                        selectecItem = item
                        isNavigating = true
                    }
                }
            }
        }
        
        return content
    }

    var body: some View {
            VStack {
                FilterComponent(textInput: $searchText, byFavorites: $filterActive, isLoading: $isLoading)
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
            } .onChange(of: searchText) { _,_ in
                filterCitiesAsync()
            }
            .onChange(of: filterActive) { _,_ in
                filterCitiesAsync()
            }  .navigationDestination(isPresented: $isNavigating) {
                if let item = selectecItem {
                    MapView(location: item)
                }
            }
    }
    
    private func filterCitiesAsync() {
        let citiesToFilter = filterActive ? favCities : cities
       // isLoading = true

        DispatchQueue.global(qos: .userInitiated).async {
            let result = citiesToFilter.filter { city in
                searchText.isEmpty || city.name.localizedCaseInsensitiveContains(searchText)
            }
            
            print("result",result.count)

            DispatchQueue.main.async {
                self.filteredCities = result
                self.isLoading = false
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
                    self.filterCitiesAsync()
                case .failure(let error):
                    print("Error on JSON", error)
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    ListView()
}




