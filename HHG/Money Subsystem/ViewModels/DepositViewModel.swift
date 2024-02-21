//
//  DepositViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 26.02.22.
//

import Foundation
import SwiftUI

final class DepositViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    
    @Published var selectedResident: Resident?
    @Published var showingResident = false
    
    // MARK: Computed Properties
    
    var depositPartners: [Resident] {
        ResidentStore.shared.residents.filter({ $0.id != userID })
    }
    
    // MARK: Methods
    
    func select(_ resident: Resident) {
        selectedResident = resident
        withAnimation(.spring()) {
            showingResident = true
        }
    }

}
