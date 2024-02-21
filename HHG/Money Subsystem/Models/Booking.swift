//
//  Booking.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.02.22.
//

import SwiftUI

struct Booking: Codable {
    
    static var mock = Booking(sender: "pfannenstiel", receiver: "niconu", timestamp: 1645974985, comment: "Test Transaktion", amount: 13.37)
    
    var id: String {
        "\(sender)-\(receiver)_\(timestamp)"
    }
    
    let sender: String
    let receiver: String
    let timestamp: Int
    let comment: String
    let amount: Double
    
    var type: BookingType {
        switch sender {
        case "team_bar":
            return .bar
        case "team_bank":
            return .bank
        case "team_haussprecher":
            return .haussprecher
        case "team_hscash":
            return .haussprecher
        case "team_tutor":
            return .tutor
        case "team_admin":
            return .printer
        default:
            switch receiver {
            case "team_bar":
                return .bar
            case "team_hscash":
                return .haussprecher
            case "team_bank":
                return .bank
            default:
                return .resident
            }
        }
    }
    
    var previewImage: Image? {
        if ["team_bar", "team_hscash", "team_bank", "team_tutor", "team_admin", "team_haussprecher"].contains(receiver) {
            return Image(receiver)
        } else {
            return type != .resident ? Image(sender) : nil
        }
    }
    
}

extension Booking: Identifiable {}
