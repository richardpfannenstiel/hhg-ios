//
//  TranslatedText.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.07.22.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
