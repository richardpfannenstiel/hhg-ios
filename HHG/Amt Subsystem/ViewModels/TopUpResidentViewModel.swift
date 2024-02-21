//
//  TopUpResidentViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.06.22.
//

import Foundation
import Combine
import SwiftUI

final class TopUpResidentViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: State
    
    @Published var receiver: Resident?
    @Published var amount = ""
    
    @Published var sendingRequest = false
    
    @Published var showingSubtileAlert = false
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    @Published var showingAlert = false
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    
    @Published var showingReceiverSelectionView = false
    
    // MARK: Stored Properties
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    var computedAmount: String {
        String(format: "%.2f", (Double(amount) ?? 0) / 100)
    }
    
    var amountNonZero: Bool {
        ((Double(amount) ?? 0) / 100) > 0
    }
    
    var buttonText: String {
        if let receiver = receiver {
            return "\(receiver.givenName) \(receiver.familyName) aufladen"
        } else {
            return "Bewohner auswählen"
        }
    }
    
    // MARK: Initialization
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = {
            UIApplication.shared.dismissKeyboard()
            dismiss()
        }
    }
    
    // MARK: Methods
    
    func action() {
        if let receiver = receiver {
            confirm(receiver)
        } else {
            showReceiverSelectionView()
        }
    }
    
    func change() {
        showReceiverSelectionView()
    }
    
    private func confirm(_ receiver: Resident) {
        alertTitle = "Confirm".localized
        alertDescription = "Are you sure that the account of %first name% %last name% should be topped up with %amount% EUR?".localized
            .replacingOccurrences(of: "%first name%", with: "\(receiver.givenName)")
            .replacingOccurrences(of: "%last name%", with: "\(receiver.familyName)")
            .replacingOccurrences(of: "%amount%", with: "\(computedAmount)")
        alertBoxes = [CustomAlertBox(action: { self.send(to: receiver) }, text: "Top up".localized), CustomAlertBox(action: {}, text: "Cancel".localized)]
        withAnimation { showingAlert.toggle() }
    }
    
    private func send(to receiver: Resident) {
        if sendingRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingRequest = true
        }
        
        let url = ServerURL.depositMoney.constructedURL
        let body = ["authtoken" : authtoken, "receiver" : "\(receiver.id)", "amount" : "\(computedAmount)"]
        
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
                    topUpSucceeded()
                } else {
                    topUpFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func topUpSucceeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            vibrate(type: .success)
            showSentAlert()
            withAnimation {
                sendingRequest = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            dismiss()
        }
    }
    
    private func topUpFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            vibrate(type: .error)
            showErrorAlert()
            withAnimation {
                sendingRequest = false
            }
        }
    }
    
    private func showSentAlert() {
        alertTitle = "Top up".localized
        alertSubtitle = "successful".localized
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
        alertSubtitle = "Action failed".localized
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
    
    func showReceiverSelectionView() {
        withAnimation(.spring()) {
            showingReceiverSelectionView = true
        }
        
    }
    
    func dismissReceiverSelectionView() {
        withAnimation(.spring()) {
            showingReceiverSelectionView = false
        }
    }
    
    func selectAmount(_ amount: Int) {
        UIApplication.shared.dismissKeyboard()
        self.amount = "\(amount)00"
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

}
