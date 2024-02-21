//
//  ImageWrapper.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.07.21.
//

import Foundation

// MARK: - ImageWrapper
/// When uploading an image, the image data needs to be stored in an object called "dataEncoded".
struct ImageWrapper: Encodable {
    var dataEncoded: Data
}
