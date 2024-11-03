//
//  ContentView.swift
//  UalaMap
//
//  Created by Maria Fernanda Paz Rodriguez on 1/11/24.
//
import SwiftUI

protocol DataLoader {
    func loadCities()
}

struct ListView: View,DataLoader {
    
    @State private var searchText: String = ""
    @State private var filterActive: Bool = false
    @State private var cities: [Location] = []
    @State private var isLoading: Bool = true
    
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
                                    HStack {
                                        Image(item.country.lowercased())
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .tint(Color("SecundaryColor"))
                                        VStack{
                                            Text(item.name)
                                            Text(item.name)
                                        }
                                        
                                    }
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
                    print(" \(self.removeDuplicateCountries(from: loadedCities))")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func removeDuplicateCountries(from cities: [Location]) -> [Location] {
        var uniqueCities = [Location]()
        var seenCountries = Set<String>()

        for city in cities {
            if !seenCountries.contains(city.country) {
                seenCountries.insert(city.country)
                uniqueCities.append(city)
            }
        }
        
        return uniqueCities
    }

}

#Preview {
    ListView()
}
