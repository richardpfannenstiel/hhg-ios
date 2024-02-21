//
//  CalendarCategory.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.10.21.
//

import SwiftUI

struct CalendarCategory: Codable {
    
    let id: Int
    let title: String
    let description: String
    let fontColorHex: String
    let backgroundColorHex: String
    let canCreate: Bool
    
    var fontColor: Color {
        Color(hex: fontColorHex)
    }
    
    var backgroundColor: Color {
        Color(hex: backgroundColorHex)
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "eventType"
        case title
        case description
        case fontColorHex = "fontColor"
        case backgroundColorHex = "backgroundColor"
        case canCreate = "canCreate"
    }
}

extension CalendarCategory: Identifiable, Hashable {}
