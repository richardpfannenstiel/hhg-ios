//
//  CalendarCardButtonStyle.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.08.21.
//

import Foundation
import SwiftUI

struct CalendarCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeIn, value: configuration.isPressed)
    }
}
