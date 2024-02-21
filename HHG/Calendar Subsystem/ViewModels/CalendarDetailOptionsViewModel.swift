//
//  CalendarDetailOptionsViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 08.10.21.
//

import SwiftUI
import Combine

final class CalendarDetailOptionsViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    let url: String
    let event: CalendarEvent
    let reminderAction: (NotificationScheduleResponse) -> ()
    let shareAction: () -> ()
    
    @Published var notificationScheduled = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    var urlTitle: String {
        if url.contains("https://signal.group/") {
            return "Signal"
        }
        if url.contains("https://chat.whatsapp.com/") {
            return "WhatsApp"
        }
        if url.contains("https://t.me/") {
            return "Telegram"
        }
        return "URL"
    }
    
    var urlDescription: String {
        if urlTitle == "URL" {
            return "Website aufrufen"
        } else {
            return "Gruppenchat beitreten"
        }
    }
    
    // MARK: Initializer
    
    init(url: String?, event: CalendarEvent, reminderAction: @escaping (NotificationScheduleResponse) -> (), shareAction: @escaping () -> ()) {
        self.url = url ?? ""
        self.event = event
        self.reminderAction = reminderAction
        self.shareAction = shareAction
        
        checkReminder()
    }
    
    // MARK: Methods
    
    func openURL() {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    func remind() {
        if notificationScheduled {
            removeReminder()
        } else {
            addReminder()
        }
    }
    
    func share() {
        shareAction()
        let pasteboard = UIPasteboard.general
        pasteboard.string = "hhg://event\(event.id)"
//        guard let urlShare = URL(string: "hhg://event\(event.id)") else { return }
//        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    private func checkReminder() {
        UNUserNotificationCenter.current().pendingNotificationRequests()
            .map({ [self] in $0.contains(where: { $0.identifier == String(event.id) }) })
            .receive(on: RunLoop.main)
            .assign(to: \.notificationScheduled, on: self)
            .store(in: &cancellables)
    }
    
    private func addReminder() {
        if event.startDate < Date() {
            return
        }
        
        let identifier = String(event.id)
        
        let content = UNMutableNotificationContent()
        content.title = "Calendar Reminder"
        content.body = "\(event.title) is starting now"
        
        let date = Date(timeIntervalSince1970: TimeInterval(event.startTime))
        let dateComponents = DateComponents(year: Int(date.numericYear), month: Int(date.numericMonth), day: Int(date.numericDay), hour: Int(date.hour), minute: Int(date.minute))
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        UNUserNotificationCenter.current().scheduleNotification(identifier: identifier, content: content, trigger: trigger)
            .receive(on: RunLoop.main)
            .sink { [self] response in
                reminderAction(response)
                
                if response == .scheduled {
                    notificationScheduled = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func removeReminder() {
        UNUserNotificationCenter.current().removePendingNotification(identifier: String(event.id))
        reminderAction(.removed)
        notificationScheduled = false
    }
}
