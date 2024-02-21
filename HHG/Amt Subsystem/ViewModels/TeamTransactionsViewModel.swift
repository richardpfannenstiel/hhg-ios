//
//  TeamTransactionsViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 26.06.22.
//

import Foundation
import Combine
import SwiftUI

final class TeamTransactionsViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: State
    
    @Published var bookings: [Booking] = []
    @Published var searchText = ""
    
    @Published var selectedBooking: Booking?
    @Published var showingBookingDetail = false
    
    @Published var showBarTransactions = true
    @Published var showGKKTransactions = true
    @Published var showTutorTransactions = true
    @Published var showPrinterTransactions = true
    @Published var showPrivateTransactions = true
    
    // MARK: Stored Properties
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    let amt: Amt
    
    // MARK: Computed Properties
    
    var balance: Double {
        bookings.reduce(0.0, { $0 + abs($1.amount) * value($1) })
    }
    
    // MARK: Initialization
    
    init(amt: Amt) {
        self.amt = amt
        loadBookings()
    }
    
    // MARK: Methods
    
    private func value(_ booking: Booking) -> Double {
        if booking.sender != amt.account {
            return booking.amount < 0 ? -1 : 1
        } else {
            return booking.amount < 0 ? 1 : -1
        }
    }
    
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
        searchText == "")
    }
    
    func sort(lhs: Booking, rhs: Booking) -> Bool {
        lhs.timestamp > rhs.timestamp
    }
    
    private func loadBookings() {
        let url = ServerURL.teamBookings.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[Booking]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .assign(to: \.bookings, on: self)
            .store(in: &cancellables)
    }
    
    func reload() {
        loadBookings()
    }

}
