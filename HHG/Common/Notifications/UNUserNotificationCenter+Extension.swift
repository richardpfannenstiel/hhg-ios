//
//  UNUserNotificationCenter+Extension.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 12.10.21.
//

import Combine
import UserNotifications

extension UNUserNotificationCenter {
    
    func pendingNotificationRequests() -> Future<[UNNotificationRequest], Never> {
      return Future { promise in
        self.getPendingNotificationRequests { requests in
          promise(.success(requests))
        }
      }
    }
    
    func scheduleNotification(identifier: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) -> Future<NotificationScheduleResponse, Never> {
        Future { promise in
            self.requestAuthorization(options: [.alert, .sound]) { granted, _ in
                if granted {
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    self.add(request) { _ in }
                    promise(.success(.scheduled))
                } else {
                    promise(.success(.noPermission))
                }
            }
        }
    }
    
    func removePendingNotification(identifier: String) {
        self.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func requestNotificationAuthorization(options: UNAuthorizationOptions) -> Future<Bool, Never> {
        Future { promise in
            self.requestAuthorization(options: options) { granted, _ in
                promise(.success(granted))
            }
        }
    }
}
