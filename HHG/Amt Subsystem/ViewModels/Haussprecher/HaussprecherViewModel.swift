//
//  HaussprecherViewModel.swift
//  HHG
//
//  Created by Marc Fett on 25.03.22.
//

import SwiftUI
import Combine

final class HaussprecherViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @ObservedObject var calendarManager: MonthlyCalendarManager
    
    @Published var showingTransactions = false
    @Published var showingTopUp = false
    @Published var showingKitchenKeyBox = false
    
    // MARK: Computed Properties
    
    var members: [Resident] {
        //[.mock, .mock]
        ResidentStore.shared.residents.filter( { $0.amts.contains(.haussprecher) })
    }
    
    var officialEventCategory: CalendarCategory {
        CalendarStore.shared.categories.first(where: { $0.canCreate && $0.id == 7 })!
    }
    
    // MARK: Initializers
    
    init(calendarManager: MonthlyCalendarManager) {
        self.calendarManager = calendarManager
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
    
    func depositResident() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: false)
            showingTopUp = true
        }
    }
    
    func dismissDepositResident() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: true)
            showingTopUp = false
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
