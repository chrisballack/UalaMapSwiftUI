//
//  CityRow.swift
//  UalaMap
//
//  Created by Christians Bonilla on 4/11/24.
//
import SwiftUI

struct CityRow: View {
    let item: Location
    
    let buttonAction: () -> Void
    
    init(item: Location, buttonAction: @escaping () -> Void) {
        self.item = item
        self.buttonAction = buttonAction
    }
    
    func isDark(country: String) -> Bool{
        
        return (UIImage(named: country.lowercased())?.averageColor() ?? UIColor.clear).isDark()
        
    }

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

                VStack(alignment: .leading) {
                    Text("\(item.name), \(item.country)")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(isDark(country: item.country) ? Color.white : Color.black)
                    
                    Text("\(item.coord.lon), \(item.coord.lat)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isDark(country: item.country) ? Color.white : Color("TextSecundaryColor"))
                    
                }

                Spacer(minLength: 16)
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        buttonAction()
                    }
                   
                }) {
                    Image(systemName: item.Favorite ? "heart.fill" : "heart")
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(item.Favorite ? Color("AccentColor") : isDark(country: item.country) ? Color.white : Color("SecundaryColor"), lineWidth: 2)
                        )
                        .foregroundColor(item.Favorite ? Color("AccentColor") : isDark(country: item.country) ? Color.white : Color("SecundaryColor"))
                        .padding(.trailing, 16)
                    
                }
               
                
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
