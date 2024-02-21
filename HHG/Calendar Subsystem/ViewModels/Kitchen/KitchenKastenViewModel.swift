//
//  KitchenKastenViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 21.06.22.
//

import Combine
import Foundation
import SwiftUI
import SwiftStomp

final class KitchenKastenViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var sendingOpenRequest = false
    @Published var status: Boxstatus = .closed
    
    @Published var boxImage = LottieView(filename: "box", loop: .playOnce)
    @Published var animationPlaying = false
    
    @Published var liveImage = LottieView(filename: "pulse", loop: .loop)
    @Published var livePlaying = false
    
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    var swiftStomp: SwiftStomp!
    
    // MARK: Computed Properties
    
    var boxIsConnected: Bool {
        guard swiftStomp != nil else {
            return false
        }
        return swiftStomp.isConnected
    }
    
    var boxIsOpen: Bool {
        boxIsConnected && status == .opened
    }
    
    var boxIsClosed: Bool {
        boxIsConnected && status == .closed
    }
    
    var boxIsActive: Bool {
        boxIsConnected && status == .active
    }
    
    var boxLedColor: Color {
        if boxIsActive {
            return .green
        }
        if boxIsOpen {
            return .blue
        }
        if boxIsClosed {
            return closingLedColor
        }
        return .gray
    }
    
    @Published var closingLedColor: Color = .gray
    
    // MARK: Methods
    
    func open() {
        if sendingOpenRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingOpenRequest = true
        }
        
        let url = ServerURL.openKeyBoxFromApp.constructedURL
        let body = ["authtoken" : authtoken]
        
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
                    openSucceeded()
                } else {
                    addFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func animateClosingLedColor(interval: TimeInterval) {
        closingLedColor = .green
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.closingLedColor = .gray
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 * interval) {
            self.closingLedColor = .green
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 * interval) {
            self.closingLedColor = .gray
        }
    }
    
    private func openSucceeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            //showOpenedAlert()
            withAnimation {
                sendingOpenRequest = false
            }
        }
    }
    
    private func addFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            showErrorAlert()
            withAnimation {
                sendingOpenRequest = false
            }
        }
    }
    
    private func showOpenedAlert() {
        alertTitle = "Box".localized
        alertSubtitle = "opened".localized
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
    
    func animateOpenbox() {
        animationPlaying = true
        boxImage.animationView.play(toFrame: 90) { _ in
            self.animationPlaying = false
        }
    }
    
    func animateClosebox() {
        animationPlaying = true
        boxImage.animationView.play(fromFrame: 100, toFrame: 164, loopMode: .playOnce) { _ in
            self.animationPlaying = false
        }
    }
    
    func startPulseAnimation() {
        livePlaying = true
        liveImage.animationView.play()
    }
    
    func stopPulseAnimation() {
        livePlaying = false
        liveImage.animationView.stop()
    }

    func connect() {
        let url = URL(string: "http://app-api.hochschulhaus-garching.de:9000/kitchenkeybox")!
        swiftStomp = SwiftStomp(host: url)
        swiftStomp.delegate = self
        swiftStomp.autoReconnect = true

        swiftStomp.connect()
    }
    
    func disconnect() {
        swiftStomp.disconnect()
    }
}

extension KitchenKastenViewModel: SwiftStompDelegate {
    
    func onConnect(swiftStomp : SwiftStomp, connectType : StompConnectType) {
        swiftStomp.subscribe(to: "/kitchenKeyBoxStatus")
        startPulseAnimation()
    }
        
    func onDisconnect(swiftStomp : SwiftStomp, disconnectType : StompDisconnectType) {
        stopPulseAnimation()
    }

    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers : [String : String]) {
        if let message = message as? String {
            switch message {
            case "\nACTIVE":
                status = .active
            case "\nOPENED":
                status = .opened
                animateOpenbox()
            case "\nCLOSED":
                status = .closed
                animateClosingLedColor(interval: 0.25)
                animateClosebox()
            default:
                print("Unknown state")
            }
        }
    }

    func onReceipt(swiftStomp : SwiftStomp, receiptId : String) {}

    func onError(swiftStomp : SwiftStomp, briefDescription : String, fullDescription : String?, receiptId : String?, type : StompErrorType) {}
    
    func onSocketEvent(eventName: String, description: String) {}
}
