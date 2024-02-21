//
//  AddToContactsViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 10.07.21.
//

import Foundation
import ContactsUI
import SwiftUI

class AddToContactsViewModel: ObservableObject {
    
    // MARK: State
    
    @Published var givenName = ""
    @Published var familyName = ""
    @Published var telephoneNumber = ""
    @Published var mail = ""
    @Published var includeLocation = true
    
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    
    // MARK: Stored Properties
    
    let house: ResidentHouse
    let apartment: String
    let dismiss: () -> ()
    
    // MARK: Initialization
    
    init(resident: Resident, dismiss: @escaping () -> ()) {
        givenName = resident.givenName
        familyName = resident.familyName
        telephoneNumber = resident.telephoneNumber ?? ""
        mail = resident.mail ?? ""
        house = resident.house
        apartment = resident.roomNumber
        self.dismiss = dismiss
    }
    
    // MARK: Methods
    
    func addToContacts() {
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(createContact(), toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            dismiss()
        } catch {
            showAlert()
        }
    }
    
    private func createContact() -> CNMutableContact {
        let contact = CNMutableContact()
        contact.givenName = givenName
        contact.familyName = familyName
        if !telephoneNumber.isEmpty {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: telephoneNumber))]
        }
        if !mail.isEmpty {
            contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: mail as NSString)]
        }
        if includeLocation {
            let postalAddress = CNMutablePostalAddress()
            postalAddress.street = "Enzianstraße \(house.number)\n(Apartment \(apartment))"
            postalAddress.city = "Garching"
            postalAddress.postalCode = "85748"
            postalAddress.country = "Germany"
            contact.postalAddresses = [CNLabeledValue(label: CNLabelHome, value: postalAddress)]
        }
        return contact
    }
    
    private func showAlert() {
        showingAlert = true
        alertTitle = "Error".localized
        alertDescription = "Please provide at least a first name and make sure you supply a valid email address and phone number.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
    }
}
