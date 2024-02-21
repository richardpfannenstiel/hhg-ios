//
//  Resident.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import Foundation

struct Resident: Codable {
    
    static let mock = Resident(uid: "apple", givenName: "Craig", familyName: "Federighi", displayName: "Craig Federighi", roomNumber: "S001", userGroups: ["resident"], mail: "craig@apple.com", telephoneNumber: "+1 942 1113391", movedIn: nil, balance: nil)
    
    let uid: String
    let givenName: String
    let familyName: String
    let displayName: String
    let roomNumber: String
    let userGroups: [String]
    let mail: String?
    let telephoneNumber: String?
    let movedIn: Int?
    let balance: String?
    var house: ResidentHouse {
        roomNumber.first == "N" ? .north : .south
    }
    var amts: [Amt] {
        userGroups.map {
            Amt(group: $0)
        }
    }
    var bigAmt: Amt? {
        amts.first(where: { $0.isbigOffice })
    }
}

extension Resident: Identifiable {
    var id: String {
        return uid
    }
}

extension Resident: Equatable {
    static func == (lhs: Resident, rhs: Resident) -> Bool {
        lhs.id == rhs.id
    }
}

extension Resident: Comparable {
    static func < (lhs: Resident, rhs: Resident) -> Bool {
        lhs.familyName < rhs.familyName
    }
}

extension Resident: BookingPartner {
    var transactionID: String {
        id
    }
}

extension Resident {
    static var appStorePreviews = [
        Resident(uid: "1", givenName: "Tim", familyName: "Cook", displayName: "Tim Cook", roomNumber: "S001", userGroups: ["resident"], mail: "tim@apple.com", telephoneNumber: "+1 942 1113392", movedIn: nil, balance: nil),
        Resident(uid: "2", givenName: "Katherine", familyName: "Adams", displayName: "Katherine Adams", roomNumber: "S002", userGroups: ["resident"], mail: "katherine@apple.com", telephoneNumber: "+1 942 1113393", movedIn: nil, balance: nil),
        Resident(uid: "3", givenName: "Eddy", familyName: "Cue", displayName: "Eddy Cue", roomNumber: "S003", userGroups: ["resident"], mail: "eddy@apple.com", telephoneNumber: "+1 942 1113393", movedIn: nil, balance: nil),
        Resident(uid: "4", givenName: "Craig", familyName: "Federighi", displayName: "Craig Federighi", roomNumber: "S004", userGroups: ["resident"], mail: "craig@apple.com", telephoneNumber: "+1 942 1113394", movedIn: nil, balance: nil),
        Resident(uid: "5", givenName: "John", familyName: "Giannandrea", displayName: "John Giannandrea", roomNumber: "S005", userGroups: ["resident"], mail: "john@apple.com", telephoneNumber: "+1 942 1113395", movedIn: nil, balance: nil),
        Resident(uid: "6", givenName: "Greg", familyName: "Joswiak", displayName: "Greg Joswiak", roomNumber: "S006", userGroups: ["resident"], mail: "greg@apple.com", telephoneNumber: "+1 942 1113396", movedIn: nil, balance: nil),
        Resident(uid: "7", givenName: "Sabih", familyName: "Khan", displayName: "Sabih Khan", roomNumber: "S007", userGroups: ["resident"], mail: "sabih@apple.com", telephoneNumber: "+1 942 1113397", movedIn: nil, balance: nil)
    ]
}
