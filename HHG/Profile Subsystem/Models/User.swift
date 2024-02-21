//
//  User.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 12.08.21.
//

import Foundation

struct User: Codable {
    let authtoken: String
    let resident: Resident
}
