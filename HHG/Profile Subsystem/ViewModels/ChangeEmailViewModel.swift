//
//  ChangeEmailViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 20.03.22.
//

import Foundation
import SwiftUI
import Combine

final class ChangeEmailViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var showingAlert = false
    @Published var showingSubtileAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    @Published var newMail = ""
    @Published var newMailRepeated = ""
    
    @Published var sendingRequest = false
    @Published var changeEmailSuccessfully = false
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    var oldMail: String {
        (ResidentStore.shared.residents.first(where: { $0.id == userID }) ?? .mock).mail ?? ""
    }
    
    var validParameters: Bool {
        !textfieldsEmpty && mailsMatch && mailStructured
    }
    
    private var mailsMatch: Bool {
        newMail == newMailRepeated
    }
    
    private var mailStructured: Bool {
        newMail.contains("@") && newMail.contains(".") &&
        newMailRepeated.contains("@") && newMailRepeated.contains(".")
    }
    
    private var textfieldsEmpty: Bool {
        newMail.isEmpty || newMailRepeated.isEmpty
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
    
    private func showMailsMismatch() {
        alertTitle = "Error".localized
        alertDescription = "The new email addresses do not match, check the spelling.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    private func showMailMisstructured() {
        alertTitle = "Error".localized
        alertDescription = "The new e-mail address does not seem to be real.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    func update() {
        if textfieldsEmpty {
            showEmptyFields()
            return
        }
        
        if !mailsMatch {
            showMailsMismatch()
            return
        }
        
        if !mailStructured {
            showMailMisstructured()
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
        
        let url = ServerURL.updateMail.constructedURL
        let body = ["authtoken" : authtoken, "oldMail" : "\(oldMail)", "newMail" : "\(newMail)"]
        
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
                        changeEmailSuccessfully = true
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
        alertTitle = "E-Mail".localized
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
