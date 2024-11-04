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

struct ListView: View,DataLoader {
    func favButtonTapped(_ location: Location) {
        if let index = cities.firstIndex(where: { $0.id == location.id }) {
            cities[index].Favorite.toggle()
            
           }
        
    }
    
    
    @State private var searchText: String = ""
    @State private var filterActive: Bool = false
    @State private var cities: [Location] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                FilterComponent(textInput: $searchText, byFavorites: $filterActive)
                if isLoading ==  true {
                    
                    ProgressView("Loading cities...")
                } else {
                    ScrollView {
                        Spacer(minLength: 16)
                        LazyVStack {
                            if cities.isEmpty {
                                Text("No cities found")
                            } else {
                                ForEach(cities, id: \.self) { item in
                                    CityRow(item: item, buttonAction: {
                                        
                                        favButtonTapped(item)
                                        
                                    })
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
               if (cities.count == 0){ loadCities() }
            }
        }
    }
    
    
    
    
    internal func loadCities() {
        let jsonManager = JSONManager()
        jsonManager.loadJSON { result in
            switch result {
            case .success(let loadedCities):
                DispatchQueue.main.async {
                    self.cities = loadedCities
                    self.isLoading = false
                    
                }
            case .failure(let error):
                print("Error on JSON", error)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
}

#Preview {
    ListView()
}



