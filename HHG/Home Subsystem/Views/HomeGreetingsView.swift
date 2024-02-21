//
//  HomeGreetingsView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 17.09.21.
//

import SwiftUI

struct HomeGreetingsView: View {
    
    let greeting: String
    let name: String
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("\(greeting.localized),")
                    .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                Text(name)
                    .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                Spacer()
            }.foregroundColor(.white)
            Spacer()
        }.padding()
    }
}

struct HomeGreetingsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeGreetingsView(greeting: "Guten Tag", name: "Richard")
            .background(Color.HHG_Blue)
    }
}
