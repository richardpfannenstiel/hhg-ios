//
//  AppNavigationStore.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 24.03.22.
//

import Foundation
import SwiftUI

final class AppNavigationStore: ObservableObject {
    
    static var shared = AppNavigationStore()
    
    // MARK: Stored Properties
    
    @Published var showingAddCalendarEvent = false
    @Published var showingCalendarEventDetails = false
    @Published var showingInvalidCalendarEvent = false
    @Published var calendarEvent: CalendarEvent?
    
    @Published var showingTransactions = false
    @Published var showingSendMoney = false
    @Published var showingUnconfirmedTransactions = false
    
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    
    // MARK: Methods
    
    func showEventDetails(id: Int) {
        TabBarStore.shared.calendar()
        if let event = CalendarStore.shared.events.first(where: { $0.id == id }) {
            calendarEvent = event
            withAnimation {
                TabBarStore.shared.setBar(bool: false)
                showingCalendarEventDetails = true
            }
        } else {
            alertTitle = "Error".localized
            alertSubtitle = "The event does not seem to exist.".localized
            alertBoxes = [CustomAlertBox(action: { withAnimation { TabBarStore.shared.setBar(bool: true) } }, text: "Okay")]
            
            withAnimation {
                TabBarStore.shared.setBar(bool: false)
                showingInvalidCalendarEvent.toggle()
            }
        }
    }
    
    func showAddCalendarEvent() {
        TabBarStore.shared.calendar()
        showingAddCalendarEvent = true
    }
    
    func showTransactions() {
        TabBarStore.shared.home()
        withAnimation(.spring()) {
            TabBarStore.shared.setBar(bool: false)
            showingTransactions = true
        }
    }
    
    func showSendMoney() {
        TabBarStore.shared.home()
        withAnimation(.spring()) {
            showingSendMoney = true
        }
    }
    
    func showUnconfirmedEvents() {
        TabBarStore.shared.office()
        withAnimation(.spring()) {
            showingUnconfirmedTransactions = true
        }
    }
    
}
