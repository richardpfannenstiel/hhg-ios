//
//  SceneDelegate.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Set the NotificationCenterDelegate to be the SceneDelegate class.
        // Functions of the protocol are implemented as an extension of the class. (see below)
        UNUserNotificationCenter.current().delegate = self
        
        let urlinfo = connectionOptions.urlContexts
        
        if let host = urlinfo.first?.url.host {
            if host.contains("event") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    AppNavigationStore.shared.showEventDetails(id: Int(host.dropFirst(5)) ?? 0)
                }
            }
        }

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // When the user opens the app through a quick action, this method is called and sets the property in AppDelegate.
        (UIApplication.shared.delegate as! AppDelegate).shortcutItemToProcess = shortcutItem
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // We'll publish any changes triggerd by the shortcut items here.
        if let shortcutItem = (UIApplication.shared.delegate as! AppDelegate).shortcutItemToProcess {
            switch shortcutItem.type {
            // Shortcut for adding a new calendar event
            case "addEvent":
                AppNavigationStore.shared.showAddCalendarEvent()
            // Shortcut for creating a new transaction
            case "showNewTransaction":
                AppNavigationStore.shared.showSendMoney()
            default:
                break
            }
            
            // Setting the shortcut item property to nil to avoid unintended actions if the app switches states again.
            (UIApplication.shared.delegate as! AppDelegate).shortcutItemToProcess = nil
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            if let host = context.url.host {
                if host.contains("event") {
                    AppNavigationStore.shared.showEventDetails(id: Int(host.dropFirst(5)) ?? 0)
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: NotificationDelegate
    
    // This function allows notifications to be displayed while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    // Handling the users reaction by tapping on notification action buttons.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
        if response.notification.request.content.categoryIdentifier == NotificationCategory.shared.transactionIdentifier {
          switch response.actionIdentifier {
          case "SHOW_TRANSACTIONS":
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                AppNavigationStore.shared.showTransactions()
            }
          break
          default:
             break
          }
       }
        if response.notification.request.content.categoryIdentifier == NotificationCategory.shared.confirmEventIdentifier {
           switch response.actionIdentifier {
           case "SHOW_UNCONFIRMED":
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                 AppNavigationStore.shared.showUnconfirmedEvents()
             }
           break
           default:
              break
           }
        }
        
       completionHandler()
    }
}

