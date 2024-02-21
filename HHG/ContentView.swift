//
//  ContentView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    var body: some View {
        if authtoken.isEmpty {
            LoginView()
                .preferredColorScheme(.light)
        } else {
            TabBarView()
                .preferredColorScheme(.light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
