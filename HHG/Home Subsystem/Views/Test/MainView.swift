//
//  TabView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 16.08.21.
//

import SwiftUI

struct MainView: View {
    
    @State var selectedTab: String = "home"
    @Namespace var animation
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        /*VStack {
            TabView(selection: $selectedTab) {
                HomeView(animation: animation, viewModel: viewModel)
                    .tag("home")
                Text("Tab2")
                    .tag("office")
                ResidentListView()
                    .tag("residents")
                Text("Tab4")
                    .tag("calendar")
            }
            CustomTabBar(selectedTab: $selectedTab)
                .offset(y: viewModel.showingTabBar ? 0 : 100)
        }.ignoresSafeArea()
        .preferredColorScheme(.light)
        .onAppear {
            UITabBar.appearance().isHidden = true
        }*/
        Text("")
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
