//
//  ContentView.swift
//  UalaMap
//
//  Created by Maria Fernanda Paz Rodriguez on 1/11/24.
//

import SwiftUI

struct ListView: View {
    
    @State private var searchText: String = ""
    @State private var FilterActivee: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                FilterComponent(textInput: $searchText, byFavorites: $FilterActivee)
                Text("Search Text: \(searchText) - Filter Active: \(FilterActivee)")
                       
                Spacer()
                
            }
            
        }
        
    }
    
}

#Preview {
    ListView()
}
