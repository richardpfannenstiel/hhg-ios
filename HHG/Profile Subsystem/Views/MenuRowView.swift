//
//  MenuRowView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 06.03.22.
//

import SwiftUI

struct MenuRowView: View {
    let title: String
    let description: String
    let icon: String
    let action: () -> ()
    
    var body: some View {

        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()
                    Text(description)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
            .frame(width: screen.width - 100, height: 60)
            .background(cardBackground)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
    }
    
    private var cardBackground: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }
    }
}

struct MenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        MenuRowView(title: "Einstellungen", description: "Konto bearbeiten", icon: "gear", action: {})
    }
}
