//
//  FirebaseNotificationDelegate.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import Firebase
import Foundation

class FirebaseNotificationDelegate: NSObject, MessagingDelegate {
    
    static var token: String?
    
    override init() {
        super.init()
        Messaging.messaging().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        FirebaseNotificationDelegate.token = fcmToken
    }
}
