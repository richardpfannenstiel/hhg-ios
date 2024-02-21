//
//  CalendarEvent.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.09.21.
//

import SwiftUI

struct CalendarEvent: Codable {
    
    static var mock = CalendarEvent(id: 1, title: "Barabend", description: "Saufen, morgens, mittags, abends", startTime: 1604580946, endTime: 1604580955, allday: false, eventType: 1, lastUpdate: 1604578946, created: 1604578946, updateCount: 1, createdBy: "pfannenstiel", confirmedBy: "pfannenstiel", confirmed: true, deleted: false, canEdit: true, imageURL: "https://app-api.hochschulhaus-garching.de/images?imageId=1"
)
    
    let id: Int
    let title: String
    let description: String
    let startTime: Int
    let endTime: Int
    let allday: Bool
    let eventType: Int
    let lastUpdate: Int
    let created: Int
    let updateCount: Int
    let createdBy: String
    let confirmedBy: String
    let confirmed: Bool
    let deleted: Bool
    let canEdit: Bool
    let imageURL: String?
    
    var startDate: Date {
        Date(timeIntervalSince1970: TimeInterval(startTime))
    }
    
    var endDate: Date {
        Date(timeIntervalSince1970: TimeInterval(endTime))
    }
    
    var image: some View {
        AsyncImage(
            url: URL(string: imageURL ?? "\(ServerURL.base)/images?imageId=\(id)")!,
            placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .HHG_Blue))
            }, image: {
                Image(uiImage: $0)
                    .resizable()
        })
    }
    
    private enum CodingKeys : String, CodingKey {
        case id
        case title
        case description
        case startTime = "starttime"
        case endTime = "endtime"
        case allday
        case eventType
        case lastUpdate = "lastupdate"
        case created
        case updateCount = "updatecount"
        case createdBy
        case confirmedBy
        case confirmed
        case deleted
        case canEdit
        case imageURL
    }
    
}

extension CalendarEvent: Identifiable {}
