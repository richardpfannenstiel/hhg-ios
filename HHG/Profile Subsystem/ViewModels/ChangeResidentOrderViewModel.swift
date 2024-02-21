//
//  ChangeResidentOrderViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.03.22.
//

import Foundation
import SwiftUI
import Combine

final class ChangeResidentOrderViewModel: ObservableObject {
    
    @AppStorage("settings.residents.sortingOrder") var sortingOrder = 0
    @AppStorage("settings.residents.displayFormat") var displayFormat = 0
    
    // MARK: Stored Properties
    
    @Published var showingSortingOrderMenu = false
    @Published var showingDisplayFormatMenu = false
    
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    var sortingOrderString: String {
        sortingOrder == 0 ? "First name, last name".localized : "Last, first name".localized
    }
    
    var displayFormatString: String {
        displayFormat == 0 ? "First name, last name".localized : "Last, first name".localized
    }
    
    // MARK: Initializers
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
    }
    
    // MARK: Methods
    
    func showSortingOrderMenu() {
        withAnimation(.spring()) {
            showingSortingOrderMenu = true
        }
    }
    
    func dismissSortingOrderMenu() {
        withAnimation(.spring()) {
            showingSortingOrderMenu = false
        }
    }
    
    func showDisplayFormatMenu() {
        withAnimation(.spring()) {
            showingDisplayFormatMenu = true
        }
    }
    
    func dismissDisplayFormatMenu() {
        withAnimation(.spring()) {
            showingDisplayFormatMenu = false
        }
    }
    
    func selectSortingOrder(order: Int) {
        sortingOrder = order
        dismissSortingOrderMenu()
    }
    
    func selectDisplayFormat(format: Int) {
        displayFormat = format
        dismissDisplayFormatMenu()
    }
}
