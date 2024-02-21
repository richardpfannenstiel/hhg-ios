//
//  BookingListViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 28.02.22.
//

import Foundation
import Combine
import SwiftUI

final class BookingListViewModel: ObservableObject {
    
    // MARK: State
    
    @Published var store = BookingStore.shared
    
    @Published var bookings: [Booking] = []
    @Published var searchText = ""
    
    @Published var selectedBooking: Booking?
    @Published var showingBookingDetail = false
    
    @Published var showBarTransactions = true
    @Published var showTutorTransactions = true
    @Published var showPrinterTransactions = true
    @Published var showPrivateTransactions = true
    
    // MARK: Stored Properties
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    init() {
        store.$bookings
            .assign(to: \.bookings, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: Methods
    
    func select(_ booking: Booking) {
        selectedBooking = booking
        UIApplication.shared.dismissKeyboard()
        withAnimation() {
            showingBookingDetail = true
        }
    }
    
    func filter(booking: Booking) -> Bool {
        (booking.comment.lowercased().hasPrefix(searchText.lowercased()) ||
        (ResidentStore.shared.residents.first(where: { $0.id == booking.sender })?.givenName ?? "") .lowercased().hasPrefix(searchText.lowercased()) ||
        (ResidentStore.shared.residents.first(where: { $0.id == booking.sender })?.familyName ?? "").lowercased().contains(searchText.lowercased()) ||
        (ResidentStore.shared.residents.first(where: { $0.id == booking.receiver })?.givenName ?? "") .lowercased().hasPrefix(searchText.lowercased()) ||
        (ResidentStore.shared.residents.first(where: { $0.id == booking.receiver })?.familyName ?? "").lowercased().contains(searchText.lowercased()) ||
        searchText == "") &&
        filterQuickSelectionBookings(booking)
    }
    
    func sort(lhs: Booking, rhs: Booking) -> Bool {
        lhs.timestamp > rhs.timestamp
    }
    
    func toggleQuickSelection(selection: BookingType) {
        // If no filters are applied, selecting one booking type will hide all other transactions
        if showBarTransactions && showTutorTransactions && showPrinterTransactions && showPrivateTransactions {
            showBarTransactions = selection == .bar
            showTutorTransactions = selection == .tutor
            showPrinterTransactions = selection == .printer
            showPrivateTransactions = selection == .resident
        } else {
            withAnimation {
                switch selection {
                case .bar:
                    if !checkEnabledQuickfilters(filter: showBarTransactions) {
                        showBarTransactions.toggle()
                    }
                case .tutor:
                    if !checkEnabledQuickfilters(filter: showTutorTransactions) {
                        showTutorTransactions.toggle()
                    }
                case .printer:
                    if !checkEnabledQuickfilters(filter: showPrinterTransactions) {
                        showPrinterTransactions.toggle()
                    }
                default:
                    if !checkEnabledQuickfilters(filter: showPrivateTransactions) {
                        showPrivateTransactions.toggle()
                    }
                }
            }
        }
        vibrate()
    }
    
    private func checkEnabledQuickfilters(filter: Bool) -> Bool {
        if filter {
            if [showPrivateTransactions, showBarTransactions, showTutorTransactions, showPrinterTransactions].filter({ $0 }).count < 2 {
                withAnimation {
                    showPrivateTransactions = true
                    showBarTransactions = true
                    showTutorTransactions = true
                    showPrinterTransactions = true
                }
                return true
            }
        }
        return false
    }
    
    private func filterQuickSelectionBookings(_ booking: Booking) -> Bool {
        switch booking.type {
        case .bar:
            return showBarTransactions
        case .printer:
            return showPrinterTransactions
        case .tutor:
            return showTutorTransactions
        default:
            return showPrivateTransactions
        }
    }
    
    private func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
}
