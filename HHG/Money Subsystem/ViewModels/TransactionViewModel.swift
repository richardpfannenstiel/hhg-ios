//
//  TransactionViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.03.22.
//

import Foundation
import SwiftUI
import Combine

final class TransactionViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var comment = ""
    @Published var amount = ""
    
    @Published var showingReceiverSelectionView = false
    
    @Published var receiver: Resident?
    
    @Published var sendingRequest = false
    @Published var moneyTransferredSuccessfully = false
    
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    var sender: Resident {
        ResidentStore.shared.residents.first(where: { $0.id == userID }) ?? .mock
    }
    
    var validParameters: Bool {
        receiver != nil && (Double(amount) ?? 0) / 100 > 0 && sufficientBalance
    }
    
    var sufficientBalance: Bool {
        BookingStore.shared.balance > ((Double(amount) ?? 0) / 100)
    }
    
    var computedAmount: String {
        "\((Double(amount) ?? 0) / 100)"
    }
    
    var computedComment: String {
        comment.isEmpty ? "Sent with the HHG App".localized : comment
    }
    
    // MARK: Initializers
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
    }
    
    convenience init(receiver: Resident, dismiss: @escaping () -> ()) {
        self.init(dismiss: dismiss)
        self.receiver = receiver
    }
    
    // MARK: Methods

    
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
    
    func send() {
        if sendingRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingRequest = true
        }
        
        let url = ServerURL.moneyTransfer.constructedURL
        let body = ["authtoken" : authtoken, "receiver" : "\(receiver!.id)", "amount" : "\(computedAmount)", "comment" : "\(computedComment)"]
        
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
                    transferSucceeded()
                } else {
                    transferFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func transferSucceeded() {
        BookingStore.shared.reloadBookings()
            .sink { [self] bookings in
                BookingStore.shared.fetchBalance()
                BookingStore.shared.bookings = bookings
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    withAnimation {
                        moneyTransferredSuccessfully = true
                    }
                    showSentAlert()
                    vibrate(type: .success)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                    dismiss()
                }
            }
            .store(in: &cancellables)
    }
    
    private func transferFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            vibrate(type: .error)
            showErrorAlert()
            withAnimation {
                sendingRequest = false
            }
        }
    }
    
    private func showSentAlert() {
        alertTitle = "Money".localized
        alertSubtitle = "sent".localized
        alertImage = Image(systemName: "checkmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    private func showErrorAlert() {
        alertTitle = "Error".localized
        alertSubtitle = "Action failed".localized
        alertImage = Image(systemName: "wifi.slash")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingAlert = false
                }
            }
        }
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
}
