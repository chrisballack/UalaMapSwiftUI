//
//  ContentView.swift
//  UalaMap
//
//  Created by Christians Bonilla on 1/11/24.
//

import SwiftUI

struct ListView: View {
    
    @StateObject private var model = CitiesViewModel() 
    @State private var isNavigating = false
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @State private var selectedItem: Location?
    
    private var cityListView: some View {
        let citiesToDisplay = model.filteredCities
        
        return Group {
            if citiesToDisplay.isEmpty {
                Text(model.filterActive ? String(localized: "noFavorites") : String(localized: "noCities"))
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
                        if model.isLoading {
                            ProgressView(String(localized: "loadingCities"))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ListWithFilter()
                        }
                        Spacer()
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.4)
                    
                    if !model.isLoading {
                        MapView(location: $selectedItem).navigationBarHidden(true)
                    }
                }
            } else {
                if model.isLoading {
                    ProgressView(String(localized: "loadingCities"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ListWithFilter()
                }
                Spacer()
            }
        }
        .onAppear {
            
            Task {
                await model.fetchCities()
                await model.fetchFavCities()
            }
            
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                self.isLandscape = UIDevice.current.orientation.isLandscape
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        }
        .onChange(of: model.searchText) { _,_ in
            Task {
                   await model.filterCities()
               }
        }
        .onChange(of: model.filterActive) { _,_ in
            Task {
                   await model.filterCities()
               }
        }
        .navigationDestination(isPresented: $isNavigating) {
            MapView(location: $selectedItem)
        }
    }
    
    internal func favButtonTapped(_ location: Location) {
        model.changeFavorites(for: location)
    }
    
    @ViewBuilder
    private func ListWithFilter() -> some View {
        VStack {
            if model.isLoading {
                ProgressView(String(localized: "loadingCities"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                FilterComponent(textInput: $model.searchText, byFavorites: $model.filterActive, isLoading: $model.isLoading)
                ScrollView {
                    Spacer(minLength: 16)
                    LazyVStack {
                        cityListView
                    }
                }
            }
        }
    }
}

#Preview {
    ListView()
}
