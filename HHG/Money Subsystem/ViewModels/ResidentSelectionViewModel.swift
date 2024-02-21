//
//  ResidentSelectionViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 24.06.22.
//

import Foundation
import SwiftUI
import Combine

final class ResidentSelectionViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    @AppStorage("settings.residents.sortingOrder") var sortingOrder = 0
    
    @Published var store = ResidentStore.shared
    
    @Published var residents: [Resident] = []
    @Published var searchText = ""
    
    @Binding var selectedResident: Resident?
    
    private var cancellables: Set<AnyCancellable> = []
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    // MARK: Initialization
    
    init(selectedResident: Binding<Resident?>, dismiss: @escaping () -> ()) {
        self._selectedResident = selectedResident
        self.dismiss = dismiss
        
        store.$residents
            .assign(to: \.residents, on: self)
            .store(in: &cancellables)
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
        withAnimation {
            selectedResident = resident
        }
        dismiss()
    }
}

