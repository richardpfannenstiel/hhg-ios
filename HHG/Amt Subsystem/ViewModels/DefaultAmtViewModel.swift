//
//  DefaultAmtViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.07.22.
//

import Foundation
import SwiftUI

final class DefaultAmtViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    
    @Published var showingAmtDetails = false
    @Published var selectedAmt: Amt?
    
    var amt: Amt? {
        ResidentStore.shared.residents
            .first(where: { $0.id == userID })?
            .amts
            .first(where: { $0 != .resident })
    }
    
    var description: String {
        if let amt = amt {
            return "Thank you for already serving as %amt%. You still have the possibility to get involved in the following offices.".localized.replacingOccurrences(of: "%amt%", with: "\(amt.rawValue)")
        } else {
            return "You have the opportunity to get involved in the following offices to enrich dorm life.".localized
        }
    }
    
    func show(_ amt: Amt) {
        selectedAmt = amt
        showingAmtDetails = true
    }
}
