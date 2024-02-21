//
//  BookingCellViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 07.07.22.
//

import Foundation
import SwiftUI

final class BookingCellViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    
    // MARK: Stored Properties
    
    let booking: Booking
    let amt: Amt?
    
    // MARK: Computed Properties
    
    var accountID: String {
        if let amtAccount = amt?.account {
            return amtAccount
        } else {
            return userID
        }
    }
    
    var bookingPartnerID: String {
        booking.sender != accountID ? booking.sender : booking.receiver
    }
    
    var bookingPartner: BookingPartner? {
        if let resident = ResidentStore.shared.residents.first(where: { $0.id == bookingPartnerID }) {
            return resident
        }
        let amt = Amt(account: bookingPartnerID)
        return amt != .resident ? amt : nil
    }
    
    var bookingPartnerName: String {
        guard let partner = bookingPartner else {
            return "Ehemaliger Bewohner"
        }
        if let resident = partner as? Resident {
            return "\(resident.givenName) \(resident.familyName)"
        }
        if let amt = partner as? Amt {
            return amt.id
        }
        return ""
    }
    
    var bookingValue: BookingValue {
        if booking.sender != accountID {
            return booking.amount < 0 ? .credit : .debit
        } else {
            return booking.amount < 0 ? .debit : .credit
        }
    }
    
    var previewPicture: AnyView {
        if let amtAccount = (bookingPartner as? Amt)?.account {
            return AnyView(Image(amtAccount)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4)))
        } else {
            return AnyView(Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.gray)
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                .overlay(Text("\(String((bookingPartner as? Resident)?.givenName.first ?? " "))\(String((bookingPartner as? Resident)?.familyName.first ?? " "))")
                            .font(Font.system(size: 20, weight: .bold, design: .rounded))
                            .kerning(0.25)
                            .foregroundColor(.white)))
        }
    }
    
    var amount: String {
        "\(bookingValue == .credit ? "-" : "")\(String(format: "%.2f", abs(booking.amount)))€"
    }
    
    // MARK: Initialization
    
    init(booking: Booking, amt: Amt? = nil) {
        self.booking = booking
        self.amt = amt
    }
    
    // MARK: Methods
}
