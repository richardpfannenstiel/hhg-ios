//
//  HomeCurve.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 17.09.21.
//

import SwiftUI

struct HomeCurve: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addCurve(to: CGPoint(x: rect.size.width, y: 0), control1: CGPoint(x: rect.size.width / 5, y: 100), control2: CGPoint(x: rect.size.width / 1.8, y: 70))
        }
    }
}
