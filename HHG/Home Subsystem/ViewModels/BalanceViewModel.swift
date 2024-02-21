//
//  BalanceViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.02.22.
//

import Foundation
import Combine
import SwiftUI

final class BalanceViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    private var cancellables: Set<AnyCancellable> = []
    
    let topUpAction: () -> ()
    let sendMoneyAction: () -> ()
    let showTransactionsAction: () -> ()
    
    @Published var balance: Double = 0
    @Published var lastTransaction: Booking?
    @Published var bookingStore = BookingStore.shared
    
    // MARK: Initialization
    
    init(topUpAction: @escaping () -> (), sendMoneyAction: @escaping () -> (), showTransactionsAction: @escaping () -> ()) {
        self.topUpAction = topUpAction
        self.sendMoneyAction = sendMoneyAction
        self.showTransactionsAction = showTransactionsAction
        
        bookingStore.$balance
            .assign(to: \.balance, on: self)
            .store(in: &cancellables)
        
        bookingStore.$bookings
            .map({ $0.sorted(by: { $0.timestamp > $1.timestamp }).first })
            .assign(to: \.lastTransaction, on: self)
            .store(in: &cancellables)
        
    }
}
