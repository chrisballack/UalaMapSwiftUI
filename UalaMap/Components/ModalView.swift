//
//  ModalView.swift
//  UalaMap
//
//  Created by Christians Bonilla on 6/11/24.
//
import SwiftUI

/// Modal to see the information of the city
struct ModalView: View {
    
    let item: Location
    let buttonAction: () -> Void
    @Binding var isLandscape: Bool
    
    init(item: Location,isLandscape:Binding<Bool>, buttonAction: @escaping () -> Void) {
        self.item = item
        self.buttonAction = buttonAction
        self._isLandscape = isLandscape
    }
    
    // Method to determine if the average color of the image is dark
    func isDark(country: String) -> Bool{
        
        return (UIImage(named: country.lowercased())?.averageColor() ?? UIColor.clear).isDark()
        
    }
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(Color("BackgroundColor"))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // Country Image
                Image(self.item.country.lowercased())
                    .resizable()
                    .cornerRadius(8)
                    .frame(height: 150)
                    .accessibilityIdentifier("CountryImageView")
                
                VStack(spacing: 8.0) {
                    
                    // City Name and Country
                    Text("\(self.item.name),\(self.item.country)").frame(maxWidth: .infinity)
                        .font(.system(size: 25, weight: .bold)).foregroundColor(isDark(country: self.item.country.lowercased()) ? Color.white : Color("TextSecundaryColor"))
                        .accessibilityIdentifier("CityNameLabel")
                    
                    // Location
                    Text("\(self.item.coord.lat),\(self.item.coord.lon)").frame(maxWidth: .infinity)
                        .font(.system(size: 20, weight: .regular)).foregroundColor(isDark(country: self.item.country) ? Color.white : Color("TextSecundaryColor"))
                        .accessibilityIdentifier("CoordinatesLabel")
                    
                    // Close Button
                    Button(action: {
                        self.buttonAction()
                    }) {
                        Text(String(localized: "Close"))
                            .padding(.horizontal)
                            .foregroundColor(isDark(country: self.item.country.lowercased()) ?  Color("Black") : Color("DarkModeText"))
                    }
                    .background(isDark(country: self.item.country.lowercased()) ? Color.white : Color("TextSecundaryColor"))
                    .foregroundColor(isDark(country: self.item.country.lowercased()) ? Color("TextSecundaryColor") : Color.white)
                    .cornerRadius(8)
                    .accessibilityIdentifier("CloseButton")
                }
                .padding(.bottom, 8)
                .cornerRadius(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIImage(named: self.item.country.lowercased())?.averageColor() ?? UIColor.clear))
                )
                .padding(.top, -16)
                
                Spacer()
            }
            .cornerRadius(8)
            .padding(self.isLandscape ? UIScreen.main.bounds.width * 0.2 : UIScreen.main.bounds.width * 0.1)
            
        }
    }

}
