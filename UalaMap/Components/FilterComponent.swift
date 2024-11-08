//
//  TwoOptionsButtons.swift
//  GameSteamSwiftUI
//
//  Created by Christians bonilla on 6/11/24.
//

import SwiftUI

/// Component to show a top filter with a button to change the list
struct FilterComponent: View {
    
    @Binding var textInput: String
    @Binding var byFavorites: Bool
    @Binding var isLoading: Bool
    
    init(textInput: Binding<String>, byFavorites: Binding<Bool>, isLoading: Binding<Bool>) {
        self._textInput = textInput
        self._byFavorites = byFavorites
        self._isLoading = isLoading
        
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: 16)
            
            HStack {
                TextField(byFavorites ? String(localized: "titleSearchFav") : String(localized: "titleSearch"), text: $textInput)
                    .padding(.leading)
                    .frame(height: 30)
                    .cornerRadius(10)
                    .accessibilityIdentifier("titleSearchTextField")
                    .foregroundStyle(Color("Black"))
                Button {
                    textInput = ""
                } label: {
                    Image(systemName: textInput.isEmpty ? "magnifyingglass" : "xmark.circle")
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color("Black"))
                }.accessibilityIdentifier("clearTextButton")

                
            }
            .padding(2)
            .background( RoundedRectangle(cornerRadius: 15)
                .stroke(Color("SecundaryColor"), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white)))
            .padding(.horizontal, 4)
            
            if (!isLoading){
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        byFavorites.toggle()
                        textInput = ""
                    }
                }) {
                    Image(systemName: byFavorites ? "heart.fill" : "heart")
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(byFavorites ? 360 : 0))
                        .opacity(byFavorites ? 1 : 0.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(byFavorites ? Color("AccentColor") : Color("SecundaryColor"), lineWidth: 2)
                        )
                        .tint(byFavorites ? Color("AccentColor") : Color("SecundaryColor"))
                    
                }
                .accessibilityValue(byFavorites ? "heart.fill" : "heart")
                .accessibilityIdentifier("favoritesButton")
                
            }
            Spacer(minLength: 16)
        } .padding(.top, 16)
    }
    
}

#Preview {
    FilterComponent(textInput: .constant(""), byFavorites: .constant(false), isLoading: .constant(false))
}
