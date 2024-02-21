//
//  RequestNotificationViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 12.10.21.
//

import SwiftUI
import Combine
import UserNotifications

final class RequestNotificationViewModel: ObservableObject {
    
    @AppStorage("settings.notifications.configured") var showingNotificationsConfigure = true
    
    let width = UIScreen.main.bounds.width
    private var cancellables: Set<AnyCancellable> = []
    
    let action: () -> ()
    
    init(action: @escaping () -> ()) {
        self.action = action
    }
    
    func configure() {
        UNUserNotificationCenter.current().requestNotificationAuthorization(options: [.alert, .sound])
            .sink { [self] granted in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                DispatchQueue.main.async { [self] in
                    showingNotificationsConfigure = false
                    action()
                }
            }
            .store(in: &cancellables)
    }
}
