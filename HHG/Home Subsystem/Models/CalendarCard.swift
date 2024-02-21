//
//  CalendarCard.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.08.21.
//

import Foundation
import SwiftUI

struct CalendarCard: Identifiable {
    
    static var cards: [CalendarCard] = [
        CalendarCard(title: "Barabend", image: "bar", color: .blue),
        CalendarCard(title: "Spieleabend", image: "cooking", color: .green)
    ]
    
    var id = UUID().uuidString
    var title: String
    var image: String
    var color: Color
}

extension CalendarCard: Equatable {}
