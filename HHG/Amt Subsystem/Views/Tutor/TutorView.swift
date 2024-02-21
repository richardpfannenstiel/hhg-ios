//
//  TutorView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 24.06.22.
//

import SwiftUI

struct TutorView: View {
    
    @StateObject var viewModel: TutorViewModel
    
    var body: some View {
        VStack {
            Text("Tutors".localized)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
                .padding(.top)
            memberView
            Spacer()
            createTutorEvent
            tutorTransactionsView
            Spacer()
        }.frame(width: screen.width)
        .background(backgroundView)
        .slideView(isPresented: $viewModel.showingTransactions) {
            TeamTransactionsView(viewModel: TeamTransactionsViewModel(amt: .tutor), showing: $viewModel.showingTransactions)
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            Color.white
        }

    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var memberView: some View {
        HStack {
            ForEach(0..<viewModel.members.count, id: \.self) { index in
                Circle()
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color.gray)
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                    .overlay(Text("\(String(viewModel.members[index].givenName.first!))\(String(viewModel.members[index].familyName.first!))")
                                .font(Font.system(size: 30, weight: .bold, design: .rounded))
                                .kerning(0.25)
                                .foregroundColor(.white))
                    .offset(x: -CGFloat(index * 25))
            }
        }.offset(x: CGFloat(viewModel.members.count - 1) * CGFloat(12.5))
    }
    
    private var createTutorEvent: some View {
        Button(action: viewModel.addEvent) {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
                    .overlay(Image(systemName: "calendar.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15))
                    .padding(.trailing, 5)
                Spacer()
                Text("Create Tutor Event".localized)
                    .font(Font.system(size: 20, weight: .medium, design: .rounded))
                    .kerning(0.25)
                Spacer()
            }.padding()
                .frame(width: screen.width - 30)
            .background(Color.white)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
        .sheet(isPresented: $viewModel.calendarManager.showingAddView) {
            CalendarEntryAddView(viewModel: CalendarEntryAddViewModel(calendarManager: viewModel.calendarManager, category: viewModel.tutorEventCategory))
        }
    }
    
    private var tutorTransactionsView: some View {
        Button(action: viewModel.showTransactions) {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.HHG_Blue)
                    .overlay(Image(systemName: "creditcard.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15))
                    .padding(.trailing, 5)
                Spacer()
                Text("Transactions".localized)
                    .font(Font.system(size: 20, weight: .medium, design: .rounded))
                    .kerning(0.25)
                Spacer()
            }.padding()
                .frame(width: screen.width - 30)
            .background(Color.white)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
    }
}

struct TutorView_Previews: PreviewProvider {
    static var previews: some View {
        TutorView(viewModel: TutorViewModel(calendarManager: .mock))
    }
}
