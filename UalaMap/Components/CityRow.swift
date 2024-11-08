//
//  CityRow.swift
//  UalaMap
//
//  Created by Christians Bonilla on 4/11/24.
//
import SwiftUI

/// The Component used to show every city in the list
struct CityRow: View {
    let item: Location
    let buttonFavorites: () -> Void
    let buttonInfo: () -> Void
    
    init(item: Location, buttonFavorites: @escaping () -> Void, buttonInfo: @escaping () -> Void) {
        self.item = item
        self.buttonFavorites = buttonFavorites
        self.buttonInfo = buttonInfo
    }
    
    /// Detemitate if the color dark or not
    /// - Parameter country: country code un lowercase to select the image
    /// - Returns: return true or false depending is de color dark or not
    func isDark(country: String) -> Bool{
        
        return (UIImage(named: country.lowercased())?.averageColor() ?? UIColor.clear).isDark()
        
    }
    
    /// include the contry flat, city name, location a button to see the information and other to select it if your favorite or not
    var body: some View {
        VStack {
            HStack {
                Image(item.country.lowercased())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.leading, 16)
                    .padding(.trailing, 8)
                    .accessibilityIdentifier("CountryImage")

                VStack(alignment: .leading) {
                    Text("\(item.name), \(item.country)")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(isDark(country: item.country) ? Color.white : Color.black)
                        .accessibilityIdentifier("CityName")

                    
                    Text("\(item.coord.lon), \(item.coord.lat)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isDark(country: item.country) ? Color.white : Color("TextSecundaryColor"))
                        .accessibilityIdentifier("Coordinates")
                    
                }
                Spacer(minLength: 16)
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        buttonInfo()
                    }
                   
                }) {
                    Image(systemName: "info")
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(isDark(country: item.country) ? Color.white : Color("SecundaryColor"), lineWidth: 2)
                        )
                        .foregroundColor(isDark(country: item.country) ? Color.white : Color("SecundaryColor"))
                    
                }
                .accessibilityIdentifier("InfoButton")
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        buttonFavorites()
                    }
                   
                }) {
                    Image(systemName: item.Favorite ? "heart.fill" : "heart")
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(item.Favorite ? Color("AccentColor") : isDark(country: item.country) ? Color.white : Color("SecundaryColor"), lineWidth: 2)
                        )
                        .foregroundColor(item.Favorite ? Color("AccentColor") : isDark(country: item.country) ? Color.white : Color("SecundaryColor"))
                        .padding(.trailing, 8)
                    
                }
                .accessibilityIdentifier("FavoriteButton")
               
                
            }
            .padding(.bottom, 16)
            .padding(.top, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIImage(named: item.country.lowercased())?.averageColor() ?? UIColor.clear))
                .shadow(radius: 2)
        )
        .padding(.horizontal, 16)
        .padding(.top, -16)
    }
}
