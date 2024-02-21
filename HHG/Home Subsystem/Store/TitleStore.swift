//
//  TitleStore.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 10.08.21.
//

import Foundation
import Combine
import SwiftUI

final class TitleStore: ObservableObject {
    
    static var shared = TitleStore()
    
    @Published var showingHeader = true
    
    func setHeader(bool: Bool) {
        withAnimation(.spring()) {
            showingHeader = bool
        }
    }
    
}
