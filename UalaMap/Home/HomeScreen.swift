//
//  ContentView.swift
//  UalaMap
//
//  Created by Christians Bonilla on 1/11/24.
//

import SwiftUI

/// Main Screen where the user will filter a see all the cities also can see the map it if the app in landscape
struct HomeScreen: View {
    
    @StateObject private var model = CitiesViewModel()
    @State private var isNavigating = false
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @State private var showFullScreenModal = false
    @State private var showModal = false
    
    /// The view is adapted depending if LandScape or not
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    VStack {
                        if model.isLoading {
                            ProgressView(String(localized: "loadingCities"))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .accessibilityIdentifier("loadingCities")
                        } else {
                            
                            FilterComponent(textInput: $model.searchText, byFavorites: $model.filterActive, isLoading: $model.isLoading)
                            ScrollView {
                                Spacer(minLength: 16)
                                LazyVStack {
                                    if model.filteredCities.isEmpty {
                                        Text(model.filterActive ? String(localized: "noFavorites") : String(localized: "noCities"))
                                    } else {
                                        ForEach(model.filteredCities, id: \.self) { item in
                                            CityRow(item: item, buttonFavorites: {
                                                favButtonTapped(item)
                                            }, buttonInfo: {
                                                modalButton(item)
                                            }).onTapGesture {
                                                model.selectedItem = item
                                                if !isLandscape {
                                                    isNavigating = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: isLandscape ? UIScreen.main.bounds.width * 0.5 : UIScreen.main.bounds.width)
                    
                    if (isLandscape && !model.isLoading) {
                        MapView(location: $model.selectedItem).navigationBarHidden(true)
                    }
                }
                
            }
            .onAppear {
                Task {
                    if (model.cities.isEmpty){
                        await model.fetchCities()
                    }
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
                MapView(location: $model.selectedItem)
            }
            if showModal {
                if let info = model.infoItem{
                    ModalView(item: info, isLandscape: $isLandscape, buttonAction: {
                        showModal.toggle()
                    })
                }
            }
        }
    }
    
    /// Action when the Favorite button in tapped in the list
    /// - Parameter location: send the item that select to add in favorites
    internal func favButtonTapped(_ location: Location) {
        model.changeFavorites(for: location)
    }
    
    /// Button to show the modal
    /// - Parameter location: send the item that select to show the information
    internal func modalButton(_ location: Location) {
        showModal.toggle()
        model.infoItem = location
    }
    
}




#Preview {
    HomeScreen()
}
