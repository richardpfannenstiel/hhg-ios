//
//  ServerURL.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.07.21.
//

import Foundation
import SwiftUI

// MARK: - ServerURL

enum ServerURL: String {
    
    static let resetPassword = "https://www.hochschulhaus-garching.de/forgotPassword.php"
    
    static var base = liveBase
    static let liveBase = "https://live-api.hochschulhaus-garching.de"
    static let testBase = "https://app-api.hochschulhaus-garching.de"
    
    case moneyTransfer = "sendMoney"
    case moneyTransferToTeam = "sendMoneyToTeam"
    case depositMoney = "despositMoney"
    case balance = "balance"
    case bookings = "bookings"
    case teamBookings = "teamBookings"
    case residents = "residents"
    case unconfirmedCalendarEntries = "unconfirmedCalendarEntries"
    case confirmCalendarEvent = "confirmCalendarEvent"
    case declineCalendarEvent = "declineCalendarEvent"
    case calendarEntries = "calendarEntries"
    case calendarCategories = "calendarCategories"
    case addCalendarEntry = "addCalendarEntry"
    case editCalendarEvent = "editCalendarEvent"
    case deleteCalendarEvent = "deleteCalendarEvent"
    case login = "authenticate"
    case logout = "deauthenticate"
    case eventParticipants = "eventParticipants"
    case addEventParticipation = "addEventParticipation"
    case deleteEventParticipation = "deleteEventParticipation"
    case registeredDevices = "getRegisteredDevices"
    case addDevice = "registerDevice"
    case updateDevice = "updateDevice"
    case deleteDevice = "deleteDevice"
    case updatePassword = "updatePassword"
    case updateMail = "updateMail"
    case updatePhone = "updatePhone"
    case setToken = "setPushToken"
    case openKeyBoxFromApp = "openKeyBoxFromApp"
    
    var constructedURL: URL {
        guard let baseURL = URL(string: ServerURL.base) else {
            fatalError("Invalid base URL: \(ServerURL.base)")
        }
        guard let url = URLComponents(url: baseURL.appendingPathComponent(self.rawValue), resolvingAgainstBaseURL: true)?.url else {
            fatalError("Unconstructable URL: \(ServerURL.base)/\(self.rawValue)")
        }
        return url
    }
    
}
