//
//  CalendarEventParticipantsView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.09.21.
//

import SwiftUI

struct CalendarEventParticipantsView: View {
    
    @StateObject var viewModel: CalendarEventParticipationViewModel
    
    var body: some View {
        VStack {
            title
            if viewModel.participantsCount > 0 {
                HStack(alignment: .top) {
                    participantsCircles
                    if viewModel.participantsCount < viewModel.participants.count {
                        moreCircle
                    }
                    Spacer()
                }
            }
        }
    }
    
    private var title: some View {
        HStack(alignment: .bottom) {
            Text("PARTICIPANTS".localized)
                .font(Font.system(size: 13, weight: .light, design: .rounded))
                .kerning(0.25)
                .foregroundColor(.secondary)
            Spacer()
            Button(action: viewModel.showAllParticipants, label: {
                Text("Show all".localized)
            })
        }
    }
    
    private var participantsCircles: some View {
        ForEach(0...(viewModel.participantsCount - 1), id: \.self) { index in
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.gray)
                .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                .overlay(Text("\(String(viewModel.participants[index].givenName.first!))\(String(viewModel.participants[index].familyName.first!))")
                    .font(Font.system(size: 20, weight: .bold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white))
                .offset(x: -CGFloat(index * 25))
        }
    }
    
    private var moreCircle: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(Color.gray)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(VStack {
                Text("+\(viewModel.participants.count - viewModel.participantsCount)")
                    .font(Font.system(size: 15, weight: .bold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                Text("more".localized)
                    .font(Font.system(size: 13, weight: .bold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                    })
            .offset(x: -CGFloat(viewModel.previewBubbleLimit * 25))
    }
}
