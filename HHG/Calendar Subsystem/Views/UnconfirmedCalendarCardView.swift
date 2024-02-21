//
//  UnconfirmedCalendarCardView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import SwiftUI

struct UnconfirmedCalendarCardView: View {
    
    @State var showingCreatorDetailView = false
    
    let event: CalendarEvent
    let action: (CalendarEventAdministrationAction, CalendarEvent) -> ()
    
    var creator: Resident {
        ResidentStore.shared.residents.first(where: { $0.id == event.createdBy }) ?? .mock
    }
    
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
            
            Divider()
            Button(action: { showingCreatorDetailView.toggle() }) {
                HStack {
                    Text("created by %first name% %last name%".localized
                        .replacingOccurrences(of: "%first name%", with: "\(creator.givenName)")
                        .replacingOccurrences(of: "%last name%", with: "\(creator.familyName)"))
                        .font(Font.system(size: 16, weight: .light, design: .rounded))
                        .kerning(0.25)
                    Spacer()
                    Image(systemName: "chevron.right")
                }.padding(.trailing, 10)
                .padding(.vertical, 5)
                .background(.white)
                .sheet(isPresented: $showingCreatorDetailView) {
                    ResidentDetailView(viewModel: ResidentDetailViewModel(resident: creator), showing: $showingCreatorDetailView)
                }
            }.buttonStyle(PlainButtonStyle())
            Divider()
            HStack {
                Button(action: { action(.confirm, event) }) {
                    Text("Confirm".localized)
                        .font(Font.system(size: 18, weight: .regular, design: .rounded))
                        .kerning(0.25)
                }
                Spacer()
                Button(action: { action(.decline, event) }) {
                    Text("Decline".localized)
                        .font(Font.system(size: 18, weight: .regular, design: .rounded))
                        .kerning(0.25)
                }
            }.padding(.trailing, 10)
            .padding(.vertical, 5)
        }.padding(.all, 10)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var logo: AnyView {
        AnyView(Image("bar")
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4)))
    }
}

struct UnconfirmedCalendarCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            UnconfirmedCalendarCardView(event: .mock, action: { _,_  in })
            Spacer()
        }.padding()
        .background(.secondary)
    }
}
