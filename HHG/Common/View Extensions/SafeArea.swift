//
//  SafeArea.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 16.08.21.
//

import SwiftUI

extension View {
    func getSafeArea() -> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
