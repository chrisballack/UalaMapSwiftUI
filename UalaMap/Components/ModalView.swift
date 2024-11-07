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
    
    func isDark(country: String) -> Bool{
        
        return (UIImage(named: country.lowercased())?.averageColor() ?? UIColor.clear).isDark()
        
    }
    
    var body: some View {
        ZStack {
            // Transparent black background with 0.5 opacity
            Rectangle()
                .fill(Color("BackgroundColor"))
                .edgesIgnoringSafeArea(.all) // Optional: make it cover the entire screen
            
            VStack {
                Spacer()
                
                Image(self.item.country.lowercased())
                    .resizable()
                    .cornerRadius(8)
                    .frame(height: 150)
                
                VStack(spacing: 8.0) {
                    Text("\(self.item.name),\(self.item.country)").frame(maxWidth: .infinity)
                        .font(.system(size: 25, weight: .bold)).foregroundColor(isDark(country: self.item.country.lowercased()) ? Color.white : Color("TextSecundaryColor"))
                    Text("\(self.item.coord.lat),\(self.item.coord.lon)").frame(maxWidth: .infinity)
                        .font(.system(size: 20, weight: .regular)).foregroundColor(isDark(country: self.item.country) ? Color.white : Color("TextSecundaryColor"))
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
