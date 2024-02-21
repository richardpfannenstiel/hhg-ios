//
//  BookingStore.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.02.22.
//

import Foundation
import Combine
import SwiftUI

final class BookingStore: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    static let shared = BookingStore()
    
    // MARK: Stored Properties
    
    @Published var balance: Double = 0
    @Published var bookings: [Booking] = []
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    init() {
        fetchBalance()
        loadBookings()
    }
    
    // MARK: Methods
    
    func fetchBalance() {
        let url = ServerURL.balance.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[String:String]> in
                print("Error: ", err)
                return Just([:])
            })
            .map({ Double($0["balance"] ?? "") ?? 0 })
            .receive(on: RunLoop.main)
            .assign(to: \BookingStore.balance, on: self)
            .store(in: &cancellables)
    }
    
    private func loadBookings() {
        let url = ServerURL.bookings.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[Booking]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .assign(to: \BookingStore.bookings, on: self)
            .store(in: &cancellables)
    }
    
    func reloadBookings() -> AnyPublisher<[Booking], Never> {
        let url = ServerURL.bookings.constructedURL
        let body = ["authtoken" : authtoken]
        
        return agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[Booking]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func reload() {
        loadBookings()
    }
}
