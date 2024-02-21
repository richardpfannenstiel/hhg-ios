//
//  AmtViewModel.swift
//  HHG
//
//  Created by Marc Fett on 25.03.22.
//

import Foundation
import SwiftUI

final class AmtViewModel: ObservableObject {
    
    @AppStorage("user.id") var userID = ""
    
    var bigAmt: Amt? {
        ResidentStore.shared.residents
            .first(where: { $0.id == userID })?
            .bigAmt
    }
}
