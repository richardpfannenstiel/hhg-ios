//
//  ResidentListViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import Foundation
import Combine
import SwiftUI

final class ResidentListViewModel: ObservableObject {
    
    @AppStorage("settings.residents.sortingOrder") var sortingOrder = 0
    @AppStorage("settings.residents.displayFormat") var displayFormat = 0
    
    // MARK: State
    
    @Published var store = ResidentStore.shared
    
    @Published var residents: [Resident] = []
    @Published var searchText = ""
    @Published var isRefreshing = false
    
    @Published var selectedResident: Resident?
    @Published var showingResident = false
    
    // MARK: Stored Properties
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    init() {
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
    
    func reload() {
        store.reload()
        isRefreshing = false
    }
    
    func select(_ resident: Resident) {
        selectedResident = resident
        UIApplication.shared.dismissKeyboard()
        withAnimation(.spring()) {
            showingResident = true
        }
    }
}
