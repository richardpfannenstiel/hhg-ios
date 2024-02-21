//
//  HomeProfileIconView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 17.09.21.
//

import SwiftUI

struct HomeProfileIconView: View {
    
    let action: () -> ()
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .leading) {
                Button(action: action, label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40, alignment: .center)
                })
                Spacer()
            }
        }.padding()
    }
}

struct HomeProfileIconView_Previews: PreviewProvider {
    static var previews: some View {
        HomeProfileIconView(action: {})
            .background(Color.HHG_Blue)
    }
}
