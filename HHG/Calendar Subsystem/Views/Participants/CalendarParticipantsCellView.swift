//
//  CalendarParticipantsCellView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.04.22.
//

import SwiftUI

struct CalendarParticipantsCellView: View {
    
    var participant: Resident
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            profilePicture
            nameView
            Spacer(minLength: 0)
            arrowView
        }.background(Color.white)
        .padding(.vertical, 5)
    }
    private var profilePicture: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(Color.gray)
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(Text("\(String(participant.givenName.first!))\(String(participant.familyName.first!))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white))
    }
    
    private var nameView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(participant.displayName)
                .fontWeight(.bold)
            Text(participant.roomNumber)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private var arrowView: some View {
        VStack {
            Spacer()
            Image(systemName: "chevron.right")
            Spacer()
        }
    }
}

struct CalendarParticipantsCellView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarParticipantsCellView(participant: .mock)
    }
}
