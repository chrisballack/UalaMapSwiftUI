//
//  ContentView.swift
//  UalaMap
//
//  Created by Maria Fernanda Paz Rodriguez on 1/11/24.
//

import SwiftUI

struct ListView: View {
    
    @State private var searchText: String = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                FilterComponent(textInput: $searchText)
                Text("Search Text: \(searchText)")
                       
                Spacer()
                
            }
            
        }
        
    }
    
}

#Preview {
    ListView()
}
