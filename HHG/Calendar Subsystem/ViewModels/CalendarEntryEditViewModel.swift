//
//  CalendarEntryEditViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.10.21.
//

import Foundation
import Combine
import SwiftUI

final class CalendarEntryEditViewModel: ObservableObject {
    
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
    
    @Published var sendingEditRequest = false
    @Published var eventEditedSuccessfully = false
    
    @Published var sendingDeleteRequest = false
    @Published var eventDeltedSuccessfully = false
    
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    let eventId: Int
    let dismissAction: () -> ()
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    var event: CalendarEvent {
        CalendarStore.shared.events.first(where: { $0.id == eventId })!
    }
    
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
    
    init(eventId: Int, dismissAction: @escaping () -> ()) {
        self.eventId = eventId
        self.dismissAction = dismissAction
        loadArguments()
    }
    
    // MARK: Methods
    
    private func loadArguments() {
        title = event.title
        
        if event.description.contains("URL: ") {
            if event.description.replacingOccurrences(of: "URL: ", with: "§").split(separator: "§").count > 1 {
                description = String(event.description
                        .replacingOccurrences(of: "URL: ", with: "§")
                        .split(separator: "§")[0])
            } else {
                description = ""
            }
            
        } else {
            description = event.description
        }
        
        if event.description.contains("URL: ") {
            url = String(event.description
                    .replacingOccurrences(of: "URL: ", with: "§")
                    .split(separator: "§").last!)
        }
        
        category = CalendarStore.shared.categories.first(where: { $0.id == event.eventType })
        
        startDate = event.startDate
        endDate = event.endDate
        allDay = event.allday
    }
    
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
        dismissAction()
    }
    
    func edit() {
        if sendingEditRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingEditRequest = true
        }
        
        let url = ServerURL.editCalendarEvent.constructedURL
        let body = ["authtoken" : authtoken, "id" : String(event.id), "title" : "\(title)", "description" : "\(computedDescription)", "starttime" : "\(Int(startDate.timeIntervalSince1970))", "endtime" : "\(Int(endDate.timeIntervalSince1970))", "eventtype" : "\(category?.id ?? 0)"]
        
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
                    editSucceeded()
                } else {
                    editFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func editSucceeded() {
        CalendarStore.shared.reloadEvents()
            .sink { [self] events in
                CalendarStore.shared.events = events
                //event = events.first(where: { $0.id == event.id })!
                showEditAlert()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    withAnimation {
                        eventEditedSuccessfully = true
                    }
                    showEditAlert()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                    close()
                }
            }
            .store(in: &cancellables)
    }
    
    private func editFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            showErrorAlert()
            withAnimation {
                sendingEditRequest = false
            }
        }
    }
    
    func delete() {
        if sendingDeleteRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingDeleteRequest = true
        }
        
        let url = ServerURL.deleteCalendarEvent.constructedURL
        let body = ["authtoken" : authtoken, "eventId" : String(event.id)]
        
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
                    deleteSucceeded()
                } else {
                    deleteFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func deleteSucceeded() {
        CalendarStore.shared.reloadEvents()
            .sink { [self] events in
                CalendarStore.shared.events = events
                showDeletedAlert()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    withAnimation {
                        eventDeltedSuccessfully = true
                    }
                    showDeletedAlert()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                    close()
                }
            }
            .store(in: &cancellables)
    }
    
    private func deleteFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            showErrorAlert()
            withAnimation {
                sendingDeleteRequest = false
            }
        }
    }
    
    private func showEditAlert() {
        alertTitle = "Event".localized
        alertSubtitle = "updated".localized
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
    
    private func showDeletedAlert() {
        alertTitle = "Event".localized
        alertSubtitle = "removed".localized
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
