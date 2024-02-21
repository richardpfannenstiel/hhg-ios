//
//  AdminViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 24.06.22.
//

import Foundation
import SwiftUI

final class AdminViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @ObservedObject var calendarManager: MonthlyCalendarManager
    
    @Published var showingTransactions = false
    @Published var showingKitchenKeyBox = false
    
    // MARK: Initializers
    
    init(calendarManager: MonthlyCalendarManager) {
        self.calendarManager = calendarManager
    }
    
    // MARK: Computed Properties
    
    var members: [Resident] {
        //[.mock, .mock, .mock, .mock, .mock]
        ResidentStore.shared.residents.filter( { $0.amts.contains(.admin) })
    }
    
    var officialEventCategory: CalendarCategory {
        CalendarStore.shared.categories.first(where: { $0.canCreate && $0.id == 7 })!
    }
    
    // MARK: Methods
    
    func addEvent() {
        calendarManager.add()
    }
    
    func showTabBar() {
        withAnimation {
            TabBarStore.shared.setBar(bool: true)
        }
    }
    
    func showTransactions() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: false)
            showingTransactions = true
        }
    }
    
    func dismissTransactions() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: true)
            showingTransactions = false
        }
    }
    
    func showKitchenBox() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: false)
            showingKitchenKeyBox = true
        }
    }
    
    func dismissKitchenBox() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: true)
            showingKitchenKeyBox = false
        }
    }
}
