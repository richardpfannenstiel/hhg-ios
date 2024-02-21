//
//  ResidentHouse.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import Foundation

enum ResidentHouse {
    case north
    case south
    
    var number: Int {
        self == ResidentHouse.north ? 5 : 7
    }
}
