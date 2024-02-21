//
//  CalendarDetailViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 21.09.21.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

final class CalendarDetailViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    @AppStorage("user.id") var userID = ""
    
    @Published var animationFinished = false
    @Published var scrollOffset: CGFloat = 0
    
    @Published var participants: [Resident] = []
    @Published var showingAllParticipantsView = false
    var selectedParticipant: Resident? {
        didSet {
            showingParticipantDetails = true
        }
    }
    @Published var userParticipates = false
    
    @Published var sendingParticipatingRequest = false
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    @Published var showingEditView = false
    @Published var showingOptions = false
    @Published var showingParticipantDetails = false
    
    // MARK: Stored Properties
    
    let eventId: Int
    var deletedEvent: CalendarEvent
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    var event: CalendarEvent {
        CalendarStore.shared.events.first(where: { $0.id == eventId }) ?? deletedEvent
    }
    
    var deleted: Bool {
        CalendarStore.shared.events.first(where: { $0.id == eventId }) == nil
    }
    
    var creatorName: String {
        ResidentStore.shared.residents.first(where: { $0.id == event.createdBy })?.givenName ?? ""
    }
    
    var canEdit: Bool {
        event.canEdit
    }
    
    var url: String? {
        if event.description.contains("URL: ") {
            return String(event.description
                    .replacingOccurrences(of: "URL: ", with: "§")
                    .split(separator: "§").last!)
        } else {
            return nil
        }
    }
    
    var description: String {
        if event.description.contains("URL: ") {
            if event.description.replacingOccurrences(of: "URL: ", with: "§").split(separator: "§").count > 1 {
                return String(event.description
                        .replacingOccurrences(of: "URL: ", with: "§")
                        .split(separator: "§")[0])
            } else {
                return ""
            }
            
        } else {
            return event.description
        }
    }
    
    var optionsSheetHeight: CGFloat {
        300 - (url != nil ? 0 : 70) - (event.startDate > Date() ? 0 : 70)
    }
    
    // MARK: Initialization
    
    init(eventId: Int) {
        self.eventId = eventId
        self.deletedEvent = CalendarStore.shared.events.first(where: { $0.id == eventId })!
        loadParticipants()
    }
    
    // MARK: Methods
    
    func animate() {
        withAnimation {
            animationFinished.toggle()
        }
    }
    
    func changeParticipation() {
        if sendingParticipatingRequest {
            return
        }
        
        sendingParticipatingRequest = true
        if userParticipates {
            removeParticipation()
        } else {
            participate()
        }
    }
    
    func loadParticipants() {
        let url = ServerURL.eventParticipants.constructedURL
        let body = ["authtoken" : authtoken, "eventId" : "\(event.id)"]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[[String : String]]> in
                print("Error: ", err)
                return Just([])
            })
            .map({ participantIDs in
                participantIDs.compactMap({ participantID in ResidentStore.shared.residents.first(where: { $0.id == participantID["uid"] }) })
            })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [self] participants in
                self.participants = participants
                userParticipates = participants.contains(where: { $0.uid == userID })
            })
            .store(in: &cancellables)
    }
    
    func participate() {
        let url = ServerURL.addEventParticipation.constructedURL
        let body = ["authtoken" : authtoken, "eventId" : "\(event.id)"]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[String : String]> in
                return Just(["error":  "connection refused"])
            })
            .map({ $0["success"] != nil })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [self] success in
                sendingParticipatingRequest = false
                if success {
                    participationAdded()
                } else {
                    participationNotChanged()
                }
            })
            .store(in: &cancellables)
    }
    
    func removeParticipation() {
        let url = ServerURL.deleteEventParticipation.constructedURL
        let body = ["authtoken" : authtoken, "eventId" : "\(event.id)"]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[String : String]> in
                return Just(["error":  "connection refused"])
            })
            .map({ $0["success"] != nil })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [self] success in
                sendingParticipatingRequest = false
                if success {
                    participationRemoved()
                } else {
                    participationNotChanged()
                }
            })
            .store(in: &cancellables)
    }
    
    func participationAdded() {
        loadParticipants()
        
        alertTitle = "Participation".localized
        alertSubtitle = "added".localized
        alertImage = Image(systemName: "checkmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    func participationNotChanged() {
        alertTitle = "Error".localized
        alertSubtitle = "Action failed".localized
        alertImage = Image(systemName: "wifi.slash")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    func participationRemoved() {
        alertTitle = "Participation".localized
        alertSubtitle = "removed".localized
        alertImage = Image(systemName: "xmark.circle.fill")
        
        loadParticipants()
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    func showOptions() {
        withAnimation(.spring()) {
        //withAnimation(Animation.easeOut(duration: 0.4)) {
            showingOptions.toggle()
        }
    }
    
    func dismissOptions() {
        withAnimation(.spring()) {
            showingOptions.toggle()
        }
    }
    
    func reminderAction(response: NotificationScheduleResponse) {
        dismissOptions()
        
        alertTitle = "Reminder".localized
        
        switch response {
        case .scheduled:
            alertSubtitle = "Alert set".localized
            vibrate(type: .success)
        case .removed:
            alertSubtitle = "Alert removed".localized
            vibrate(type: .success)
        case .noPermission:
            alertSubtitle = "Action failed".localized
            vibrate(type: .error)
        }
        
        alertImage = Image(systemName: response == .scheduled ? "checkmark.circle.fill" : "xmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    func shareAction() {
        dismissOptions()
        vibrate(type: .success)
        
        alertTitle = "Link copied".localized
        alertSubtitle = "to clipboard".localized
        alertImage = Image(systemName: "checkmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    func edit() {
        showingEditView = true
    }
    
    func dismissEdit() {
        CalendarStore.shared.setCurrentMonth(month: event.startDate.fullMonth)
        showingEditView = false
    }
    
    func showAllParticipants() {
        withAnimation(.spring()) {
            showingAllParticipantsView = true
        }
        
    }
    
    func dismissAllParticipants() {
        withAnimation(.spring()) {
            showingAllParticipantsView = false
        }
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
