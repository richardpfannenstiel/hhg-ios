//
//  MenuViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 06.03.22.
//

import Foundation
import SwiftUI

final class MenuViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var showingSettings = false
    
    let wikiURL = "https://wiki.hochschulhaus-garching.de/doku.php/de:start"
    let fileserverURL = "http://files.hochschulhaus-garching.de/"
    
    let dismiss: () -> ()
    
    // MARK: Initializer
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
    }
    
    // MARK: Methods
    
    func showSettings() {
        showingSettings = true
        dismiss()
    }
    
    func closeSettings() {
        showingSettings = false
    }
    
    func showWiki() {
        if let url = URL(string: wikiURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func showFileserver() {
        if let url = URL(string: fileserverURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut() {
        authtoken = ""
    }
    
}
