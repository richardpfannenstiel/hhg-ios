//
//  NotificationCategory.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import Foundation
import UserNotifications

struct NotificationCategory {
    
    static var shared = NotificationCategory()
    
    let transactionIdentifier = "SHOW_TRANSACTIONS"
    let confirmEventIdentifier = "SHOW_UNCONFIRMED"
    
    let transactionTitle = "Alle Transaktionen"
    let confirmEventTitle = "Unbestätigte Kalendereinträge"
    
    func registerCategories() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let transactionsCategory = category(identifier: transactionIdentifier, title: transactionTitle)
        let unconfirmedCategory = category(identifier: confirmEventIdentifier, title: confirmEventTitle)
        
        // Register the notification type.
        notificationCenter.setNotificationCategories([transactionsCategory, unconfirmedCategory])
    }
    
    private func category(identifier: String, title: String) -> UNNotificationCategory {
        // Define the custom actions.
        let action = UNNotificationAction(identifier: identifier,
              title: title,
              options: UNNotificationActionOptions.foreground)
        // Define the notification type
        let category =
              UNNotificationCategory(identifier: identifier,
              actions: [action],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        return category
    }
}
