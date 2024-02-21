//
//  TabBarView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 17.09.21.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var amtViewModel = AmtViewModel()
    @StateObject var calendarViewModel = CalendarElegantViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $homeViewModel.selectedTab) {
                Home(viewModel: homeViewModel)
                    .tag("home")
                AmtView(calendarManager: calendarViewModel.calendarManager, viewModel: amtViewModel)
                    .tag("office")
                ResidentListView()
                    .tag("residents")
                CalendarMonthView(viewModel: calendarViewModel)
                    .tag("calendar")
            }
            CustomTabBar(selectedTab: $homeViewModel.tabStore.selectedTab)
                .offset(y: homeViewModel.showingTabBar ? 0 : 100)
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
