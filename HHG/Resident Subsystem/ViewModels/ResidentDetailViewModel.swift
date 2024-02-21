//
//  ResidentDetailViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import Foundation
import Combine
import SwiftUI
import ContactsUI

final class ResidentDetailViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    
    // MARK: State
    
    @Published var resident: Resident
    
    @Published var showingNoContactsAccessAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    
    
    @Published var showingMoneyTransfer = false
    @Published var showingAddToContacts = false
    
    @Published var showing = false
    
    @Published var profileScale: CGFloat = 0
    
    // MARK: Stored Properties
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    init(resident: Resident) {
        self.resident = resident
    }
    
    // MARK: Methods
    
    func scaleProfile() {
        withAnimation(Animation.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 0.5)) {
            profileScale = 1
        }
    }
    
    func equalsUser() -> Bool {
        resident.uid == userID
    }
    
    func message() {
        guard let phone = resident.telephoneNumber else { return }
        if let url = URL(string: "sms:\(phone)") {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func call() {
        guard let phone = resident.telephoneNumber else { return }
        if let url = URL(string: "tel://\(phone)") {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func email() {
        guard let email = resident.mail?.lowercased() else { return }
        if let url = URL(string: "mailto:\(email)") {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func sendMoney() {
        if equalsUser() { return }
        showingMoneyTransfer = true
    }
    
    func closeSendMoney() {
        showingMoneyTransfer = false
    }
    
    func addToContacts() {
        if equalsUser() { return }
        if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == CNAuthorizationStatus.denied {
            DispatchQueue.main.async { [self] in
                showNoContactsAccessAlert()
            }
        } else {
            if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == CNAuthorizationStatus.notDetermined {
                CNContactStore().requestAccess(for: CNEntityType.contacts) { [self] (granted, _) in
                    DispatchQueue.main.async { [self] in
                        if granted {
                            showingAddToContacts = true
                        } else {
                            showNoContactsAccessAlert()
                        }
                    }
                }
            } else {
                self.showingAddToContacts = true
            }
        }
    }
    
    func dismissAddToContacts() {
        showingAddToContacts = false
    }
    
    func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func showNoContactsAccessAlert() {
        alertTitle = "No access".localized
        alertDescription = "The app does not have write access to your contact book. To export resident data, you must allow access in the device settings.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Cancel".localized), CustomAlertBox(action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)}, text: "Settings".localized)]
        showAlert()
    }
    
    private func showAlert() {
        withAnimation {
            showingNoContactsAccessAlert.toggle()
        }
    }
}
