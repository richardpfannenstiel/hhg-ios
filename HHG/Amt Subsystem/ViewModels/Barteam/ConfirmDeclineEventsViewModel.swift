//
//  ConfirmDeclineEventsViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import SwiftUI
import Combine

final class ConfirmDeclineEventsViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var showingAlert = false
    @Published var showingSubtileAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    @Published var sendingRequest = false
    @Published var updateEventSuccessfully = false
    
    @Published var unconfirmedEvents: [CalendarEvent] = []
    @Published var selectedEvent: CalendarEvent?
    
    let dismiss: () -> ()
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    // MARK: Initializers
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
        loadUnconfirmedEvents()
    }
    
    // MARK: Methods
    
    func select(_ action: CalendarEventAdministrationAction, event: CalendarEvent) {
        selectedEvent = event
        
        alertTitle = "Are you sure?".localized
        alertDescription = "This action cannot be undone".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Cancel".localized), CustomAlertBox(action: { [self] in send(action: action) }, text: "\(action == .confirm ? "Confirm".localized : "Decline".localized)")]
        
        withAnimation {
            showingAlert.toggle()
        }
    }
    
    private func loadUnconfirmedEvents() {
        let url = ServerURL.unconfirmedCalendarEntries.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[CalendarEvent]> in
                print("Error: ", err)
                return Just([])
            })
            .map({ events in events.sorted(by: { $0.startTime < $1.startTime }) })
            .receive(on: RunLoop.main)
            .assign(to: \.unconfirmedEvents, on: self)
            .store(in: &cancellables)
    }
    
    func send(action: CalendarEventAdministrationAction) {
        guard let id = selectedEvent?.id else {
            return
        }
        
        if sendingRequest {
            return
        } else {
            sendingRequest = true
        }
        
        let url = (action == .confirm ? ServerURL.confirmCalendarEvent : ServerURL.declineCalendarEvent).constructedURL
        let body = ["authtoken" : authtoken, "eventId" : "\(id)"]
        
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
                    changeSucceeded(action)
                } else {
                    changeFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func changeSucceeded(_ action: CalendarEventAdministrationAction) {
        CalendarStore.shared.reloadEvents()
            .sink { [self] events in
                
                CalendarStore.shared.events = events
                loadUnconfirmedEvents()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    withAnimation {
                        updateEventSuccessfully = true
                    }
                    showChangedAlert(action)
                    vibrate(type: .success)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                    dismiss()
                    
                }
            }
            .store(in: &cancellables)
    }
    
    private func changeFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            vibrate(type: .error)
            showErrorAlert()
            withAnimation {
                sendingRequest = false
            }
        }
    }
    
    private func showChangedAlert(_ action: CalendarEventAdministrationAction) {
        alertTitle = "Event".localized
        alertDescription = action == .confirm ? "confirmed".localized : "declined".localized
        alertImage = Image(systemName: "checkmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingSubtileAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingSubtileAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingSubtileAlert = false
                }
            }
        }
    }
    
    private func showErrorAlert() {
        alertTitle = "Error".localized
        alertDescription = "Action failed".localized
        alertImage = Image(systemName: "wifi.slash")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingSubtileAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingSubtileAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingSubtileAlert = false
                }
            }
        }
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
