//
//  ResidentCellView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import SwiftUI

struct ResidentCellView: View {
    
    @AppStorage("settings.residents.sortingOrder") var sortingOrder = 0
    @AppStorage("settings.residents.displayFormat") var displayFormat = 0
    
    let resident : Resident
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            profilePicture
            nameView
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .padding(.trailing, 40)
        }.padding(.vertical)
    }
    
    private var profilePicture: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(Color.gray)
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(Text("\(String(resident.givenName.first!))\(String(resident.familyName.first!))")
                        .font(Font.system(size: 20, weight: .bold, design: .rounded))
                        .kerning(0.25)
                        .foregroundColor(.white))
    }
    
    private var nameView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(displayFormat == 0 ? "\(resident.givenName) \(resident.familyName)" : "\(resident.familyName) \(resident.givenName)")
//                    .fontWeight(.bold)
                    .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                    .kerning(0.25)
            }
            Text(resident.roomNumber)
                .font(Font.system(size: 13, weight: .light, design: .rounded))
                .kerning(0.25)
//                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ResidentCellView_Previews: PreviewProvider {
    static var previews: some View {
        ResidentCellView(resident: Resident.mock)
    }
}
