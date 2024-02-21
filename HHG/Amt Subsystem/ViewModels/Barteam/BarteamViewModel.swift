//
//  BarteamViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import SwiftUI
import Combine

final class BarteamViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @ObservedObject var calendarManager: MonthlyCalendarManager
    @Published var navigationStore = AppNavigationStore.shared
    
    @Published var showingConfirmEvents = false
    @Published var showingTransactions = false
    @Published var showingTopUp = false
    @Published var showingKitchenKeyBox = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    var members: [Resident] {
        //[.mock, .mock, .mock, .mock, .mock]
        ResidentStore.shared.residents.filter( { $0.amts.contains(.barTeam) })
    }
    
    var barEventCategory: CalendarCategory {
        CalendarStore.shared.categories.first(where: { $0.canCreate && $0.id == 1 })!
    }
    
    // MARK: Initializers
    
    init(calendarManager: MonthlyCalendarManager) {
        self.calendarManager = calendarManager
        
        navigationStore.$showingUnconfirmedTransactions
            .assign(to: \.showingConfirmEvents, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: Methods
    
    func addEvent() {
        calendarManager.add()
    }
    
    func showConfirmEventsView() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: false)
            showingConfirmEvents = true
        }
    }
    
    func dismissConfirmEventsView() {
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: true)
            showingConfirmEvents = false
        }
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
