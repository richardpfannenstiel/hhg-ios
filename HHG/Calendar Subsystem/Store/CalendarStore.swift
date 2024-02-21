//
//  CalendarStore.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.09.21.
//

import Foundation
import Combine
import SwiftUI

final class CalendarStore: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    static let shared = CalendarStore()
    
    // MARK: Stored Properties
    
    @Published var events: [CalendarEvent] = []
    @Published var monthEvents: [String : [CalendarEvent]] = [ : ]
    @Published var currentMonthEvents: [CalendarEvent] = []
    
    @Published var categories: [CalendarCategory] = []
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    var nextEvent: CalendarEvent? {
        events.filter({
            //$0.eventType < 8 &&
            $0.confirmed &&
            !$0.deleted &&
            Date().timeIntervalSince1970.isLessThanOrEqualTo(Double($0.endTime))
        }).first
    }
    
    // MARK: Initialization
    
    init() {
        storeEvents()
        loadCategories()
    }
    
    // MARK: Methods
    
    func setCurrentMonth(month: String) {
        currentMonthEvents = events.filter({ $0.startDate.fullMonth == month })
    }
    
    func reloadEvents() -> AnyPublisher<[CalendarEvent], Never> {
        let url = ServerURL.calendarEntries.constructedURL
        let body = ["authtoken" : authtoken]
        
        return agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[CalendarEvent]> in
                print("Error: ", err)
                return Just([])
            })
            .map({ events in events.sorted(by: { $0.startTime < $1.startTime }) })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func reloadCategories() {
        let url = ServerURL.calendarCategories.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[CalendarCategory]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .assign(to: \CalendarStore.categories, on: self)
            .store(in: &cancellables)
    }
    
    private func storeEvents() {
        let url = ServerURL.calendarEntries.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[CalendarEvent]> in
                print("Error: ", err)
                return Just([])
            })
            .map({ events in events.sorted(by: { $0.startTime < $1.startTime }) })
            .receive(on: RunLoop.main)
            .assign(to: \CalendarStore.events, on: self)
            .store(in: &cancellables)
    }
    
    private func loadCategories() {
        let url = ServerURL.calendarCategories.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[CalendarCategory]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .assign(to: \CalendarStore.categories, on: self)
            .store(in: &cancellables)
    }
}

