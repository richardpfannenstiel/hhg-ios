//
//  KeyboardHeightHelper.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.06.22.
//

import UIKit
import SwiftUI
import Foundation

class KeyboardHeightHelper: ObservableObject {
    
    @Published var keyboardHeight: CGFloat = 0

    init() {
        self.listenForKeyboardNotifications()
    }
    
    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                guard let userInfo = notification.userInfo,
                                                    let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                                                
            withAnimation {
                self.keyboardHeight = keyboardRect.height
            }
                                                
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
            withAnimation {
                self.keyboardHeight = 0
            }
        }
    }
}
