//
//  Device.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.03.22.
//

import SwiftUI

struct Device: Codable {
    
    static var mock = Device(id: 1394, mac: "45:b8:33:f7:23:99", description: "iPhone", timestampRegistered: 1602935587)
    static var mocks = [Device(id: 1394, mac: "45:b8:33:f7:23:99", description: "iPhone", timestampRegistered: 1602935587), Device(id: 1395, mac: "45:b8:33:f7:23:99", description: "iPad", timestampRegistered: 1602935587), Device(id: 1396, mac: "45:b8:33:f7:23:99", description: "Nintendo Switch", timestampRegistered: 1602935587), Device(id: 1397, mac: "45:b8:33:f7:23:99", description: "MacBook Pro M1", timestampRegistered: 1602935587)]
    
    let id: Int
    let mac: String
    let description: String
    let timestampRegistered: Int
    
    var previewImage: Image {
        let description = description.lowercased()
        if description.contains("phone") || description.contains("handy") || description.contains("mobile") {
            return Image(systemName: "iphone")
        }
        if description.contains("ipad") || description.contains("tablet") {
            return Image(systemName: "ipad")
        }
        if description.contains("xbox") || description.contains("ps") || description.contains("nintendo") || description.contains("switch") {
            return Image(systemName: "gamecontroller")
        }
        return Image(systemName: "desktopcomputer")
    }
    
    private enum CodingKeys : String, CodingKey {
        case id = "deviceId"
        case mac
        case description
        case timestampRegistered = "registered"
    }
}

extension Device: Comparable {
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Device, rhs: Device) -> Bool {
        lhs.timestampRegistered < rhs.timestampRegistered
    }
}

extension Device: Identifiable {}
