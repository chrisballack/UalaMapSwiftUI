//
//  TwoOptionsButtons.swift
//  GameSteamSwiftUI
//
//  Created by Dev IOS on 11/12/23.
//

import SwiftUI

struct FilterComponent: View {
    
    @Binding private var textInput: String
    @State private var byFavorites: Bool = false
    
    init(textInput: Binding<String>) {
           self._textInput = textInput // Asigna el binding directamente
       }

    
    
    var body: some View {
        
        HStack {
            
            Spacer(minLength: 16)
            
        HStack {
            
            TextField(byFavorites ? String(localized: "titleSearchFav") : String(localized: "titleSearch"), text: $textInput)
                .padding(.leading)
                .frame(height: 30)
                .background(Color.white)
                .cornerRadius(10)
                

            Image(systemName: "magnifyingglass")
                .frame(width: 30, height: 30)
                .cornerRadius(10)
                .tint(Color("SecundaryColor"))
            

        }
        .padding(2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("SecundaryColor"), lineWidth: 2)
        )
        .padding(.horizontal, 4)
            
            Button {
                
                withAnimation(.easeInOut(duration: 2)) {
                    
                    byFavorites.toggle()
                    
                }
                
            } label: {
                
                Button {
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        
                        byFavorites.toggle()
                        textInput = ""
                        
                    }
                    
                } label: {
                    
                    Image(systemName: byFavorites ? "heart.fill" : "heart")
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(byFavorites ? 360 : 0))
                        .opacity(byFavorites ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.3), value: byFavorites)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("SecundaryColor"), lineWidth: 2)
                        )
                        .tint(Color("SecundaryColor"))
                    
                }

            }
            
            Spacer(minLength: 16)
            
        }
        
    }
    
}

#Preview {
    FilterComponent(textInput: .constant(""))
}
