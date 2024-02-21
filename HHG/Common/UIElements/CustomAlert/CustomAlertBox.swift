//
//  CustomAlertBox.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.08.21.
//

import Foundation

struct CustomAlertBox: Identifiable {
    var id: String {
        text
    }
    
    let action: () -> ()
    let text: String
}
