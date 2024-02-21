//
//  SmallCalendarCardView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 17.09.21.
//

import SwiftUI

struct SmallCalendarCardView: View {
    
    let event: CalendarEvent
    let animation: Namespace.ID?
    
    var body: some View {
        VStack {
            HStack {
                logo
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(Font.system(size: 16, weight: .medium, design: .rounded))
                        .kerning(0.25)
                    Text("\(Date(timeIntervalSince1970: TimeInterval(event.startTime)).time) - \(Date(timeIntervalSince1970: TimeInterval(event.endTime)).time)")
                        .foregroundColor(.gray)
                        .font(Font.system(size: 15, weight: .light, design: .rounded))
                        .kerning(0.25)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(Date(timeIntervalSince1970: TimeInterval(event.startTime)).shortDayNumeric)
                        .font(Font.system(size: 25, weight: .semibold, design: .rounded))
                        .kerning(0.25)
                        .foregroundColor(Color.black)
                    Text(Date(timeIntervalSince1970: TimeInterval(event.startTime)).shortDay)
                        .font(Font.system(size: 16, weight: .light, design: .rounded))
                        .kerning(0.25)
                        .foregroundColor(Color.black)
                }.padding(.trailing, 10)
            }
            .padding(.all, 10)
        }.frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var logo: AnyView {
        AnyView(event.image
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4)))
    }
}

struct SmallCalendarCardView_Previews: PreviewProvider {
    
    @Namespace static var animation
    
    static var previews: some View {
        SmallCalendarCardView(event: CalendarEvent.mock, animation: animation)
    }
}
