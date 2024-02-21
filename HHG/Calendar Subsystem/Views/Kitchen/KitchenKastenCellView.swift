//
//  KitchenKastenCellView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.06.22.
//

import SwiftUI

struct KitchenKastenCellView: View {
    
    let event: CalendarEvent
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.brown)
                    .overlay(Image("keys")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30))
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("Kitchen reservation".localized)
                        .font(Font.system(size: 16, weight: .medium, design: .rounded))
                        .kerning(0.25)
                    Text("\(Date(timeIntervalSince1970: TimeInterval(event.startTime)).time) - \(Date(timeIntervalSince1970: TimeInterval(event.endTime)).time)")
                        .foregroundColor(.gray)
                        .font(Font.system(size: 15, weight: .light, design: .rounded))
                        .kerning(0.25)
                }
                Spacer()
                Image(systemName: "chevron.right")
                
            }
        }.padding()
        .background(Color.white)
        .frame(width: screen.width - 30)
        .cornerRadius(10)
    }
}

struct KitchenKastenCellView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenKastenCellView(event: .mock)
    }
}
