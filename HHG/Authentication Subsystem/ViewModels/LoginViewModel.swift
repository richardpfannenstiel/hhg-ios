//
//  LoginViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.08.21.
//

import Foundation
import Combine
import SwiftUI

final class LoginViewModel: ObservableObject {
    
    // MARK: AppStore
    
    @AppStorage("user.authtoken") var authtoken = ""
    @AppStorage("user.id") var userID = ""
    
    // MARK: State
    
    @Published var username = ""
    @Published var password = ""
    @Published var showingPasswordClear = false
    
    @Published var circleAnimation = false
    @Published var logoAnimation = false
    @Published var loginAnimation = false
    
    @Published var opacity: Double = 1
    @Published var circlesOffset: CGFloat = -50
    
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    
    // MARK: Stored Properties
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    private var rotatingAnimation: Animation {
        Animation.interpolatingSpring(stiffness: 18, damping: 5)
            .repeatForever()
    }
    
    var credentialsEmpty: Bool {
        username.isEmpty || password.isEmpty
    }
    
    // MARK: Methods
    
    func login() {
        checkBeta()
        
        setCircles(offset: -50)
        
        dismissKeyboard()
        animate(login: true, opacity: 1)
        let url = ServerURL.login.constructedURL
        let body = ["username" : username, "password" : password]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<User?> in
                return Just(nil)
            })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { self.handleLoginResult(user: $0) })
            .store(in: &cancellables)
    }
    
    func forgotPassword() {
        setCircles(offset: -50)
        showForgotPasswordAlert()
    }
    
    func checkBeta() {
        if ["richard", "pfannenstiel", "apple"].contains(username) {
            ServerURL.base = ServerURL.testBase
        } else {
            ServerURL.base = ServerURL.liveBase
        }
    }
    
    func animate(login: Bool, opacity: Double) {
        withAnimation(Animation.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
            logoAnimation.toggle()
            self.opacity = opacity
        }
        withAnimation(.interpolatingSpring(stiffness: 18, damping: 5)) {
            circleAnimation.toggle()
            if login {
                loginAnimation.toggle()
            }
        }
    }
    
    func setCircles(offset: CGFloat) {
        withAnimation(.interpolatingSpring(stiffness: 18, damping: 5)) {
            circlesOffset = offset
        }
    }
    
    // MARK: Private Functions
    
    private func handleLoginResult(user: User?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            guard let user = user else {
                self.loginFailed()
                return
            }
            self.userID = user.resident.uid
            self.authtoken = user.authtoken
            
            CalendarStore.shared.reloadCategories()
            BookingStore.shared.reload()
            BookingStore.shared.fetchBalance()
            
            self.setAPNsToken()
        }
    }
    
    private func setAPNsToken() {
        guard let token = FirebaseNotificationDelegate.token else {
            print("Could not find APNs token")
            return
        }
        
        let url = ServerURL.setToken.constructedURL
        let body = ["authtoken" : "\(authtoken)", "push_token" : "\(token)"]
        
        agent.sendData(to: url, with: body)
            .sink(receiveValue: { success in
                print("Token \(success ? "" : "not") published")
            })
            .store(in: &cancellables)

    }
    
    private func loginFailed() {
        animate(login: true, opacity: 0)
        showInvalidLogin()
    }
    
    private func resetPassword() {
        if let url = URL(string: ServerURL.resetPassword) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showAlert() {
        withAnimation {
            showingAlert.toggle()
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.dismissKeyboard()
    }
    
    private func showForgotPasswordAlert() {
        alertTitle = "Forgot password?".localized
        alertDescription = "Please visit the intranet website for instructions on resetting your password.".localized
        alertBoxes = [CustomAlertBox(action: resetPassword, text: "Reset".localized), CustomAlertBox(action: {}, text: "Cancel".localized)]
        showAlert()
    }
    
    private func showInvalidLogin() {
        alertTitle = "Bad login!".localized
        alertDescription = "Please check username and password.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Back".localized)]
        showAlert()
    }

}
