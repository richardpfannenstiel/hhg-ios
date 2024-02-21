//
//  HaussprecherAccount.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 28.06.22.
//

import Foundation

enum HaussprecherAccount: String, CaseIterable, Identifiable {
    
    var id: String { self.rawValue }
    
    case BANK = "Bank"
    case BARGELD = "Bargeld"
    case HAUSSPRECHER = "Haussprecher"
    case WOHNHEIMSFEIER = "Wohnheimsfeier"
}
