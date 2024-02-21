//
//  ChangePasswordViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 08.03.22.
//

import Foundation
import SwiftUI
import Combine

final class ChangePasswordViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let minPasswordLength = 8
    
    @Published var updatingPassword = false
    
    @Published var showingAlert = false
    @Published var showingSubtileAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var newPasswordRepeated = ""
    
    @Published var showingPasswordClear = false
    
    @Published var sendingRequest = false
    @Published var changePasswordSuccessfully = false
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    var validParameters: Bool {
        !textfieldsEmpty && passwordsMatch && passwordsComplex
    }
    
    private var passwordsMatch: Bool {
        newPassword == newPasswordRepeated
    }
    
    private var passwordContainsUpperAndLowercaseLetters: Bool {
        newPassword.lowercased() != newPassword && newPassword.uppercased() != newPassword
    }
    
    private var passwordContainsNumber: Bool {
        newPassword.contains(where: { numbers.contains(String($0)) })
    }
    
    private var passwordIsLongEnough: Bool {
        newPassword.count >= minPasswordLength
    }
    
    private var passwordsComplex: Bool {
        passwordsMatch && passwordContainsUpperAndLowercaseLetters && passwordContainsNumber && passwordIsLongEnough
    }
    
    private var textfieldsEmpty: Bool {
        oldPassword.isEmpty || newPassword.isEmpty || newPasswordRepeated.isEmpty
    }
    
    // MARK: Initializers
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
    }
    
    // MARK: Methods
    
    private func showWrongOldPassword() {
        alertTitle = "Error".localized
        alertDescription = "The old password seems to be wrong.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    private func showEmptyFields() {
        alertTitle = "Error".localized
        alertDescription = "Please fill in all text fields.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    private func showPasswordsMismatch() {
        alertTitle = "Error".localized
        alertDescription = "The new passwords do not match, check the spelling.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    private func showPasswordNotComplex() {
        alertTitle = "Error".localized
        alertDescription = "New passwords must be at least 8 characters long and contain a capital letter and a number.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    func update() {
        if textfieldsEmpty {
            showEmptyFields()
            return
        }
        
        if !passwordsMatch {
            showPasswordsMismatch()
            return
        }
        
        if !passwordsComplex {
            showPasswordNotComplex()
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
        
        let url = ServerURL.updatePassword.constructedURL
        let body = ["authtoken" : authtoken, "oldPassword" : "\(oldPassword)", "newPassword" : "\(newPassword)"]
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            withAnimation {
                changePasswordSuccessfully = true
            }
            showChangedAlert()
            vibrate(type: .success)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            dismiss()
        }
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
        alertTitle = "Password".localized
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
