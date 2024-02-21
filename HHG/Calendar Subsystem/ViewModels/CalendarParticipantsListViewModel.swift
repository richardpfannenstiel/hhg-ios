//
//  CalendarParticipantsListViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 24.06.22.
//

import Foundation
import SwiftUI

final class CalendarParticipantsListViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    @AppStorage("settings.residents.sortingOrder") var sortingOrder = 0
    
    @Published var searchText = ""
    @Published var showingDetailView = false
    @Published var selectedResident: Resident?
    
    let participants: [Resident]
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    // MARK: Initialization
    
    init(participants: [Resident], dismiss: @escaping () -> ()) {
        self.participants = participants
        self.dismiss = dismiss
    }
    
    // MARK: Methods
    
    func filter(resident: Resident) -> Bool {
        resident.familyName.lowercased().hasPrefix(searchText.lowercased()) ||
        resident.givenName.lowercased().hasPrefix(searchText.lowercased()) ||
        resident.roomNumber.lowercased().contains(searchText.lowercased()) ||
        searchText == ""
    }
    
    func sort(lhs: Resident, rhs: Resident) -> Bool {
        sortingOrder == 0 ? lhs.givenName < rhs.givenName : lhs.familyName < rhs.familyName
    }
    
    func select(_ resident: Resident) {
        selectedResident = resident
        withAnimation(.spring()) {
            showingDetailView = true
        }
    }
}
