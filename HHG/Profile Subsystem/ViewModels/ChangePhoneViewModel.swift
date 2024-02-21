//
//  ChangePhoneViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.03.22.
//

import Foundation
import SwiftUI
import Combine

final class ChangePhoneViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var showingAlert = false
    @Published var showingSubtileAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    @Published var newPhone = ""
    @Published var newPhoneRepeated = ""
    
    @Published var sendingRequest = false
    @Published var changePhoneSuccessfully = false
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    var oldPhone: String {
        (ResidentStore.shared.residents.first(where: { $0.id == userID }) ?? .mock).telephoneNumber ?? ""
    }
    
    var validParameters: Bool {
        !textfieldsEmpty && numbersMatch && numbersStructured
    }
    
    private var numbersMatch: Bool {
        newPhone == newPhoneRepeated
    }
    
    private var numbersStructured: Bool {
        var valid = true
        newPhone.forEach { character in
            if !["+", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(character) {
                valid = false
            }
        }
        return valid && newPhone.count > 8 && newPhone.count < 20
    }
    
    private var textfieldsEmpty: Bool {
        newPhone.isEmpty || newPhoneRepeated.isEmpty
    }
    
    // MARK: Initializers
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
    }
    
    // MARK: Methods
    
    private func showEmptyFields() {
        alertTitle = "Error".localized
        alertDescription = "Please fill in all text fields.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    private func showPhoneMismatch() {
        alertTitle = "Error".localized
        alertDescription = "The new phone numbers do not match, check the spelling.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    private func showPhoneMisstructured() {
        alertTitle = "Error".localized
        alertDescription = "The new phone number does not seem to be real.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    func update() {
        if textfieldsEmpty {
            showEmptyFields()
            return
        }
        
        if !numbersMatch {
            showPhoneMismatch()
            return
        }
        
        if !numbersStructured {
            showPhoneMisstructured()
            return
        }
        dismissKeyboard()
        send()
    }
    
    private func showAlert() {
        withAnimation {
            showingAlert.toggle()
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.dismissKeyboard()
    }
    
    func send() {
        if sendingRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingRequest = true
        }
        
        let url = ServerURL.updatePhone.constructedURL
        let body = ["authtoken" : authtoken, "oldPhoneNumber" : "\(oldPhone)", "newPhoneNumber" : "\(newPhone)"]
        
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
                    changeSucceeded()
                } else {
                    changeFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func changeSucceeded() {
        ResidentStore.shared.reloadResidents()
            .sink { [self] residents in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    withAnimation {
                        changePhoneSuccessfully = true
                    }
                    showChangedAlert()
                    vibrate(type: .success)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                    dismiss()
                    ResidentStore.shared.residents = residents
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
    
    private func showChangedAlert() {
        alertTitle = "Phone".localized
        alertDescription = "changed".localized
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
