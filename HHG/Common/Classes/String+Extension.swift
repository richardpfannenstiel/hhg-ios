//
//  String+Extension.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.03.22.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
