//
//  HomeViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.08.21.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("settings.notifications.configured") var showingNotificationsConfigure = true
    
    @Published var currentCalendarCard: CalendarCard?
    @Published var selectedUpcomingEvent: CalendarEvent?
    @Published var showingDetail: Bool = false
    
    @Published var showingTabBar = false
    @Published var selectedTab: String = "home"
    
    @Published var logoAnimation = false
    @Published var logoRotation: Double = 0
    @Published var scrollOffset: CGFloat = 0
    
    @Published var frame: CGRect = .zero
    @Published var readers: [Int : GeometryProxy] = [ : ]
    
    @Published var showingProfileMenu = false
    @Published var showingProfileFullScreen = false
    
    @Published var showingDepositView = false
    @Published var showingTransactionsView = false
    @Published var showingSendMoneyView = false
    @Published var showingKitchenBoxView = false
    
    @Published var viewState = CGSize.zero
    
    // MARK: Stored Properties
    
    @Published var calendarStore = CalendarStore.shared
    @Published var tabStore = TabBarStore.shared
    @Published var navigationStore = AppNavigationStore.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let animationDuration: Double = 1
    
    // MARK: Computed Properties
    
    var iconRotation: Double {
        if scrollOffset < 150 {
            return logoRotation + (Double(scrollOffset) / 1.111)
        }
        return 90
    }
    
    var iconSize: CGFloat {
        if !logoAnimation {
            return 150
        }
        if scrollOffset < 150 {
            if scrollOffset < 0 {
                return 200 - (-scrollOffset / 1.5)
            }
            return 200 - (scrollOffset / 1.5)
        }
        return 100
    }
    
    var iconOffsetX: CGFloat {
        if !logoAnimation {
            return 0
        }
        if width / 2.5 - scrollOffset > 0 {
            return width / 2.5 - scrollOffset
        }
        return 0
    }
    
    var iconOffsetY: CGFloat {
        if !logoAnimation {
            return 0
        }
        if width / 2.5 - scrollOffset > 0 {
            return -height / 2 + scrollOffset + 15
        }
        return -height / 2 + width / 2.5 + 15
    }
    
    var headerOpacity: Double {
        if scrollOffset < 50 {
            if scrollOffset < 0 {
                return Double(1 - (-scrollOffset / 50))
            }
            return Double(1 - (scrollOffset / 50))
        }
        return 0
    }
    
    var backgroundOffset: CGFloat {
        if !logoAnimation {
            return 0
        }
        return max(height / 3 - scrollOffset > 0 ? height / 3 - scrollOffset + (kitchenReservationEvent != nil ? -75 : 0) : 0, 0)
    }
    
    var upcomingEvents: [CalendarEvent] {
        Array((CalendarStore.shared.events.filter({
            //$0.eventType < 8 &&
            $0.confirmed &&
            !$0.deleted &&
            Date().timeIntervalSince1970.isLessThanOrEqualTo(Double($0.endTime))
        }).prefix(3)))
    }
    
    var kitchenReservationEvent: CalendarEvent? {
        CalendarStore.shared.events.first {
            $0.eventType == 10 &&
            $0.confirmed &&
            !$0.deleted &&
            $0.createdBy == userID &&
            $0.startDate < Date() &&
            $0.endDate > Date()
        }
    }
    
    var userName: String {
        ResidentStore.shared.residents.first(where: {
            $0.id == userID
        })?.givenName ?? "Bewohner"
    }
    
    var greeting: String {
        let hour = Int(Date().hour) ?? 12
        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<16:
            return "Good Day"
        case 16..<18:
            return "Hello"
        case 18..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
    // MARK: Initialization
    
    init() {
        navigationStore.$showingTransactions
            .assign(to: \.showingTransactionsView, on: self)
            .store(in: &cancellables)
        navigationStore.$showingSendMoney
            .assign(to: \.showingSendMoneyView, on: self)
            .store(in: &cancellables)
        
        tabStore.$showingTabBar
            .assign(to: \.showingTabBar, on: self)
            .store(in: &cancellables)
        tabStore.$selectedTab
            .assign(to: \.selectedTab, on: self)
            .store(in: &cancellables)
        calendarStore.$events
            .sink(receiveValue: { events in
                if !events.isEmpty {
                    self.animate()
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: Methods
    
    func showTabBar() {
        withAnimation {
            showingTabBar = true
        }
    }
    
    func animate() {
        if !logoAnimation {
            withAnimation(Animation.easeInOut(duration: animationDuration)) {
                logoAnimation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(Animation.easeInOut(duration: self.animationDuration - 0.1)) {
                        self.logoRotation = -45
                        self.showingTabBar = true
                    }
                }
            }
        }
    }
    
    func showCalendarDetailView(event: CalendarEvent) {
        selectedUpcomingEvent = event
        withAnimation {
            showingDetail = true
            showingTabBar = false
        }
    }
    
    func showProfileMenuView() {
        withAnimation(.spring()) {
            showingTabBar = false
            showingProfileMenu = true
        }
        
    }
    
    func dismissProfileMenuView() {
        withAnimation(.spring()) {
            showingTabBar = true
            showingProfileMenu = false
        }
    }
    
    func showDepositView() {
        withAnimation(.spring()) {
            showingTabBar = false
            showingDepositView = true
        }
    }
    
    func dismissDepositView() {
        withAnimation(.spring()) {
            showingTabBar = true
            showingDepositView = false
        }
    }
    
    func showTransactionsView() {
        withAnimation(.spring()) {
            showingTabBar = false
            showingTransactionsView = true
        }
    }
    
    func dismissTransactionsView() {
        withAnimation(.spring()) {
            showingTabBar = true
            showingTransactionsView = false
        }
    }
    
    func showSendMoneyView() {
        withAnimation(.spring()) {
            showingSendMoneyView = true
        }
    }
    
    func dismissSendMoneyView() {
        withAnimation(.spring()) {
            showingSendMoneyView = false
        }
    }
    
    func showKitchenBoxView() {
        withAnimation(.spring()) {
            showingTabBar = false
            showingKitchenBoxView = true
        }
    }
    
    func dismissKitchenBoxView() {
        withAnimation(.spring()) {
            showingTabBar = true
            showingKitchenBoxView = false
        }
    }
}
