//
//  TabBarStore.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 16.08.21.
//

import Foundation
import SwiftUI

final class TabBarStore: ObservableObject {
    
    static var shared = TabBarStore()
    
    @Published var showingTabBar = false
    @Published var selectedTab: String = "home"
    
    func setBar(bool: Bool) {
        withAnimation {
            showingTabBar = bool
        }
    }
    
    func home() {
        selectedTab = "home"
    }
    
    func office() {
        selectedTab = "office"
    }
    
    func residents() {
        selectedTab = "residents"
    }
    
    func calendar() {
        selectedTab = "calendar"
    }
    
}
