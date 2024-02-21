//
//  AppDelegate.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import UIKit
import Firebase
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @AppStorage("user.id") var userID = ""

    var firebase: FirebaseNotificationDelegate?
    
    // This property will be set in SceneDelegate if a shortcut item was pressed on the devices home screen.
    var shortcutItemToProcess: UIApplicationShortcutItem?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configuring FireBase and settings the Notification delegate
        FirebaseApp.configure()
        firebase = FirebaseNotificationDelegate()
        Messaging.messaging().delegate = firebase
        
        // Register notification categories to handle action button presses.
        application.registerForRemoteNotifications()
        NotificationCategory.shared.registerCategories()
        
        application.shortcutItems = [UIApplicationShortcutItem(type: "addEvent",
                                        localizedTitle: "Kalendareintrag",
                                        localizedSubtitle: "Erstelle ein neues Event",
                                        icon: UIApplicationShortcutIcon(type: .date)),
                                     UIApplicationShortcutItem(type: "showNewTransaction",
                                        localizedTitle: "Neue Transaktion",
                                        localizedSubtitle: nil,
                                        icon: UIApplicationShortcutIcon(systemImageName: "creditcard"))]
        
        // Check if beta user is supplied.
        if ["richard", "pfannenstiel", "apple"].contains(userID) {
            ServerURL.base = ServerURL.testBase
        }
        
        return true
    }
    
    // MARK: Remote Notification Registration
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // This print can be used to show the APNs device token in the XCode console.
        // FOR TESTING: print("Device Token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Registration failed, do nothing.
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // This will be called when a new scene session is being created.
        // Grab a reference to the shortcutItem to use in the scene:
        if let shortcutItem = options.shortcutItem {
            shortcutItemToProcess = shortcutItem
        }

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

