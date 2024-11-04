//
//  TwoOptionsButtons.swift
//  GameSteamSwiftUI
//
//  Created by Dev IOS on 11/12/23.
//

import SwiftUI

struct FilterComponent: View {
    
    @Binding var textInput: String
    @Binding var byFavorites: Bool
    
    init(textInput: Binding<String>, byFavorites: Binding<Bool>) {
        self._textInput = textInput
        self._byFavorites = byFavorites
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
                    .accessibilityIdentifier("titleSearchTextField")
                    .foregroundStyle(Color("TextPrimaryColor"))

                Image(systemName: "magnifyingglass")
                    .frame(width: 30, height: 30)
                    .tint(Color("SecundaryColor"))
            }
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("SecundaryColor"), lineWidth: 2)
            )
            .padding(.horizontal, 4)

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


            Spacer(minLength: 16)
        }
    }

}

#Preview {
    FilterComponent(textInput: .constant(""), byFavorites: .constant(false))
}
