//
//  ScrollOffsetPreferenceKey.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 17.09.21.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
