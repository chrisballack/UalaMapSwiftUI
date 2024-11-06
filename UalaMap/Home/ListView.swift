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
    @State private var filteredCities: [Location] = []
    @State private var isNavigating = false
    @State private var selectedItem: Location?
    
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    let _SQLManager = SQLManager()
    
    private var cityListView: some View {
        let citiesToDisplay = filteredCities
        
        return Group {
            if citiesToDisplay.isEmpty {
                Text(filterActive ? String(localized: "noFavorites") : String(localized: "noCities"))
            } else {
                ForEach(citiesToDisplay, id: \.self) { item in
                    CityRow(item: item, buttonAction: {
                        favButtonTapped(item)
                    }).onTapGesture {
                        selectedItem = item
                        if !isLandscape {
                            isNavigating = true
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if isLandscape {
                HStack {
                    VStack {
                        if isLoading {
                            ProgressView(String(localized: "loadingCities"))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ListWithFilter()
                        }
                        Spacer()
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.4)
                    
                    if !isLoading {
                        MapView(location: $selectedItem).navigationBarHidden(true)
                    }
                }
            } else {
                
                if isLoading {
                    ProgressView(String(localized: "loadingCities"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ListWithFilter()
                }
                Spacer()
            }
        }
        .onAppear {
            loadInitialData()
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                self.isLandscape = UIDevice.current.orientation.isLandscape
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        }
        .onChange(of: searchText) { _,_ in filterCitiesAsync() }
        .onChange(of: filterActive) { _,_ in filterCitiesAsync() }
        .navigationDestination(isPresented: $isNavigating) {
            MapView(location: $selectedItem)
        }
    }
    
    private func loadInitialData() {
        if cities.isEmpty { loadCities() }
        if favCities.isEmpty {
            favCities = _SQLManager.fetchAllFavorites()
        }
    }
    
    private func filterCitiesAsync() {
        let citiesToFilter = filterActive ? favCities : cities
        DispatchQueue.global(qos: .userInitiated).async {
            let result = citiesToFilter.filter { city in
                searchText.isEmpty || city.name.localizedCaseInsensitiveContains(searchText)
            }
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
                favCities.removeAll { $0.id == location.id }
            }
            
            DispatchQueue.global(qos: .background).async {
                if cities[index].Favorite {
                    _SQLManager.insertFavorites(location: cities[index])
                } else {
                    _SQLManager.deleteFavorite(by: cities[index].id)
                }
            }
            filterCitiesAsync()
        }
    }
    
    @ViewBuilder
    private func ListWithFilter() -> some View {
        VStack {
            if isLoading {
                ProgressView(String(localized: "loadingCities"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                FilterComponent(textInput: $searchText, byFavorites: $filterActive, isLoading: $isLoading)
                ScrollView {
                    Spacer(minLength: 16)
                    LazyVStack {
                        cityListView
                    }
                }
            }
        }
    }
    
    internal func loadCities() {
        isLoading = true
        let jsonManager = JSONManager(sqlManager: _SQLManager)
        jsonManager.loadJSON { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loadedCities):
                    self.cities = loadedCities
                    self.filterCitiesAsync()
                case .failure(let error):
                    print("Error loading cities:", error)
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    ListView()
}
