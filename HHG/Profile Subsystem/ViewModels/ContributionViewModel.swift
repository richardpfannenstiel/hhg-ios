//
//  ContributionViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 24.04.22.
//

import SwiftUI

final class ContributionViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    @AppStorage("user.id") var userID = ""
    
    @Published var confetti = LottieView(filename: "confetti", loop: .playOnce)
    @Published var animationPlaying = false
    
    let dismiss: () -> ()
    
    // MARK: Initializer
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
    }
    
    // MARK: Methods
    
    func love() {
        vibrate(type: .success)
        animationPlaying = true
        confetti.animationView.play(toFrame: 110) { _ in
            self.animationPlaying = false
        }
    }
    
    func feedback() {
        let email = "app@hochschulhaus-garching.de"
        let subject = "Feedback - iOS"
        let body = "Release - \(Bundle.main.releaseVersionNumber ?? "N/A"), Build - \(Bundle.main.buildVersionNumber ?? "N/A")\nUserID: \(userID)\n\n Feedback:"
        let coded = "mailto:\(email)?subject=\(subject)&body=\(body)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let emailURL = URL(string: coded ?? "mailto:\(email)") {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    func contribute() {
        let email = "app@hochschulhaus-garching.de"
        let subject = "Contribution Offer"
        let body = """
                Dear Developers,\n
                I would like to offer my help in order to maintain and further extend the project.\n\n
                Name:
                (Please provide your first and last name) \n
                Contact Information:
                (Provide an email, phone number, etc.) \n
                Expertise:
                (How would you like to contribute? Do you have experience in particular fields?
                We are mainly looking for designers, iOS and Android developers with Swift / Kotlin experience, respectively).\n
                Optional: What would you like to work on?\n
        """
        let coded = "mailto:\(email)?subject=\(subject)&body=\(body)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let emailURL = URL(string: coded ?? "mailto:\(email)") {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
