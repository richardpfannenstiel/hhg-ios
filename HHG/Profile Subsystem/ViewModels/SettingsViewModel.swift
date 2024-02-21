//
//  SettingsViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 06.03.22.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    
    @Published var showingPasswordChange = false
    @Published var showingEmail = false
    @Published var showingPhone = false
    @Published var showingResidentsOrder = false
    @Published var showingDevices = false
    @Published var showingContributions = false
    @Published var showingExperimental = false
    
    let dismiss: () -> ()
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
    }
    
    func close() {
        dismiss()
    }
    
    func showPasswordChange() {
        withAnimation {
            showingPasswordChange = true
        }
    }
    
    func dismissPasswordChange() {
        withAnimation {
            showingPasswordChange = false
        }
    }
    
    func showEmail() {
        withAnimation {
            showingEmail = true
        }
    }
    
    func dismissEmail() {
        withAnimation {
            showingEmail = false
        }
    }
    
    func showPhone() {
        withAnimation {
            showingPhone = true
        }
    }
    
    func dismissPhone() {
        withAnimation {
            showingPhone = false
        }
    }
    
    func showResidentsOrder() {
        withAnimation {
            showingResidentsOrder = true
        }
    }
    
    func dismissResidentsOrder() {
        withAnimation {
            showingResidentsOrder = false
        }
    }
    
    func showDevicesList() {
        withAnimation {
            showingDevices = true
        }
    }
    
    func dismissDevicesList() {
        withAnimation {
            showingDevices = false
        }
    }
    
    func showContributions() {
        withAnimation {
            showingContributions = true
        }
    }
    
    func dismissContributions() {
        withAnimation {
            showingContributions = false
        }
    }
    
    func showExperimental() {
        withAnimation {
            showingExperimental = true
        }
    }
    
    func dismissExperimental() {
        withAnimation {
            showingExperimental = false
        }
    }
}
