//
//  BookingDetailViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.03.22.
//

import Foundation
import SwiftUI

final class BookingDetailViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    @AppStorage("settings.booking.beverages") var advancedBeveragesEnabled = false
    
    @Published var showingMoneyTransferView = false
    @Published var showingResidentView = false
    
    @Published var beverages: [String : [Double]] = [:]
    
    // MARK: Stored Properties
    
    let booking: Booking
    let amt: Amt?
    
    // MARK: Computed Properties
    
    var bookingDate: Date {
        Date(timeIntervalSince1970: TimeInterval(booking.timestamp / 1000)).addingTimeInterval(TimeInterval(2 * 3600))
    }
    
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
            return "ehemaligen Bewohner"
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
    
    var sentTextPrefix: String {
        if amt != nil {
            return bookingValue == .credit ? "You paid_plural".localized : "You received_plural".localized
        } else {
            return bookingValue == .credit ? "You paid_singular".localized : "You received_singular".localized
        }
    }
    
    var sentTextSuffix: String {
        if bookingValue == .credit {
            guard let partner = bookingPartner else {
                return "to a former resident".localized
            }
            if let resident = partner as? Resident {
                return "to %first name% %last name%".localized
                    .replacingOccurrences(of: "%first name%", with: "\(resident.givenName)")
                    .replacingOccurrences(of: "%last name%", with: "\(resident.familyName)")
            }
            if let amt = partner as? Amt {
                switch amt {
                    case .barTeam:
                    return "to the Bar".localized
                    case .admin:
                    return "for the use of the printer".localized
                    case .tutor:
                    return "to the Tutors".localized
                    case .haussprecher:
                    return "to the House Speakers".localized
                    default:
                    return "to the Bank".localized
                }
            }
        } else {
            guard let partner = bookingPartner else {
                return "from a former resident".localized
            }
            if let resident = partner as? Resident {
                return "from %first name% %last name%".localized
                    .replacingOccurrences(of: "%first name%", with: "\(resident.givenName)")
                    .replacingOccurrences(of: "%last name%", with: "\(resident.familyName)")
            }
            if let amt = partner as? Amt {
                switch amt {
                    case .barTeam:
                    return "from the Barteam".localized
                    case .admin:
                    return "from the Admins".localized
                    case .tutor:
                    return "from the Tutors".localized
                    case .haussprecher:
                    return "from the House Speakers".localized
                    default:
                    return "from the Bank".localized
                }
            }
        }
        return ""
    }
    
    var previewPicture: AnyView {
        if let amtAccount = (bookingPartner as? Amt)?.account {
            return AnyView(Image(amtAccount)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4)))
        } else {
            return AnyView(Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.gray)
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                .overlay(Text("\(String((bookingPartner as? Resident)?.givenName.first ?? " "))\(String((bookingPartner as? Resident)?.familyName.first ?? " "))")
                            .font(Font.system(size: 30, weight: .bold, design: .rounded))
                            .kerning(0.25)
                            .foregroundColor(.white)))
        }
    }
    
    var isBeverageBooking: Bool {
        advancedBeveragesEnabled && (accountID == "team_bar" || bookingPartnerID == "team_bar")
    }
    
    // MARK: Initialization
    
    init(booking: Booking, amt: Amt? = nil) {
        self.booking = booking
        self.amt = amt
        
        if isBeverageBooking {
            calculateBeverages()
        }
    }
    
    // MARK: Methods
    
    private func calculateBeverages() {
        if !booking.comment.contains("R") {
            return
        }
        let contents = booking.comment.split(separator: "R")[1].dropFirst(2).dropLast()
        let items = contents.split(separator: " ")
        
        for item in items {
            let quantity = Double(item.split(separator: "x")[0]) ?? 0.00
            let price = Double(item.split(separator: "x")[1]) ?? 0.00
            
            switch price {
            case 0.50:
                beverages["softdrink"] = [quantity, price]
            case 0.70:
                beverages["softdrink"] = [quantity, price]
            case 0.85:
                beverages["beer"] = [quantity, price]
            case 1.30:
                beverages["beer"] = [quantity, price]
            case 0.60:
                beverages["snacks1"] = [quantity, price]
            case 1.00:
                beverages["snacks2"] = [quantity, price]
            case 2.00:
                beverages["cocktail"] = [quantity, price]
            case 3.00:
                beverages["cocktail"] = [quantity, price]
            default:
                beverages["other"] = [quantity, price]
            }
        }
    }
    
    func showMoneyTransfer() {
        showingMoneyTransferView.toggle()
    }
    
    func showResidentView() {
        showingResidentView.toggle()
    }
    
    func dismissMoneyTransfer() {
        showingMoneyTransferView.toggle()
    }
    
    func dismissResidentView() {
        showingResidentView.toggle()
    }
    
}
