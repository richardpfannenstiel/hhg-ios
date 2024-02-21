//
//  CalendarEntryAddViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.10.21.
//

import Foundation
import Combine
import SwiftUI

final class CalendarEntryAddViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var title = ""
    @Published var description = ""
    @Published var url = ""
    @Published var category: CalendarCategory?
    
    @Published var allDay = false
    @Published var startDate = Date()
    @Published var endDate = Date()
    
    @Published var showingCategorySelector = false
    @Published var animationAmount: CGFloat = 0
    
    @Published var sendingAddRequest = false
    @Published var eventAddedSuccessFully = false
    
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    @ObservedObject var calendarManager: MonthlyCalendarManager
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    var validEntry: Bool {
        !title.isEmpty && category != nil
    }
    
    var computedDescription: String {
        if url.isEmpty {
            return description
        } else {
            return "\(description)URL: \(url)"
        }
    }
    
    var startDateProxy: Binding<Date> {
        Binding<Date>(get: { self.startDate }, set: {
            self.startDate = $0
            if self.startDate > self.endDate {
                self.endDate = self.startDate.afterNextHour
                
            }
        })
    }
    
    var endDateProxy: Binding<Date> {
        Binding<Date>(get: { self.endDate }, set: {
            self.endDate = $0
            if self.endDate < self.startDate {
                self.startDate = self.endDate.hourBefore
            }
        })
    }
    
    // MARK: Initializer
    
    init(calendarManager: MonthlyCalendarManager) {
        self.calendarManager = calendarManager
        startDate = calendarManager.selectedDate?.setHour(hour: 9) ?? Date()
        endDate = calendarManager.selectedDate?.setHour(hour: 11) ?? Date()
    }
    
    convenience init(calendarManager: MonthlyCalendarManager, category: CalendarCategory) {
        self.init(calendarManager: calendarManager)
        self.category = category
    }
    
    // MARK: Methods
    
    func pasteURL() {
        if let copiedURL = UIPasteboard.general.string {
            url = copiedURL
        }
    }
    
    func dismissCategorySelector(category: CalendarCategory?) {
        if category != nil {
            self.category = category
        }
        animationAmount = 0
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 0.25) { [self] in
            showingCategorySelector = false
        }
    }
    
    func showCategorySelector() {
        withAnimation { showingCategorySelector = true }
        animationAmount = 1
        UIApplication.shared.dismissKeyboard()
    }
    
    func close() {
        calendarManager.showingAddView = false
    }
    
    func add() {
        if sendingAddRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingAddRequest = true
        }
        
        let url = ServerURL.addCalendarEntry.constructedURL
        let body = ["authtoken" : authtoken, "title" : "\(title)", "description" : "\(computedDescription)", "starttime" : "\(Int(startDate.timeIntervalSince1970))", "endtime" : "\(Int(endDate.timeIntervalSince1970))", "eventtype" : "\(category?.id ?? 0)"]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[String : String]> in
                guard let _ = err as? URLError else {
                    return Just(["success" : ""])
                }
                return Just(["error" : ""])
            })
            .map({ $0["success"] != nil })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [self] success in
                if success {
                    addSucceeded()
                } else {
                    addFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func addSucceeded() {
        CalendarStore.shared.reloadEvents()
            .sink { [self] events in
                CalendarStore.shared.events = events
                reloadPages()
                showAddedAlert()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    withAnimation {
                        eventAddedSuccessFully = true
                    }
                    showAddedAlert()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                    close()
                }
            }
            .store(in: &cancellables)
    }
    
    private func reloadPages() {
        calendarManager.scrollToDay(startDate.addingTimeInterval(TimeInterval(-60 * 60 * 24 * 30)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            calendarManager.scrollToDay(startDate)
        }
    }
    
    private func addFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            showErrorAlert()
            withAnimation {
                sendingAddRequest = false
            }
        }
    }
    
    private func showAddedAlert() {
        alertTitle = "Event".localized
        alertSubtitle = "added".localized
        alertImage = Image(systemName: "checkmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    private func showErrorAlert() {
        alertTitle = "Error".localized
        alertSubtitle = "Action failed".localized
        alertImage = Image(systemName: "wifi.slash")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
}
