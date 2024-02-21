//
//  BarteamView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import SwiftUI

struct BarteamView: View {
    
    @StateObject var viewModel: BarteamViewModel
    
    var body: some View {
        VStack {
            Text("Barteam")
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
                .padding(.top)
            memberView
            Spacer()
            createBarEventView
            kitchenKeyBoxView
            confirmDeclineEventsView
            topUpAccountView
            barteamTransactionsView
            Spacer()
        }.frame(width: screen.width)
        .background(backgroundView)
        .slideView(isPresented: $viewModel.showingConfirmEvents) {
            ConfirmDeclineEventsView(viewModel: ConfirmDeclineEventsViewModel(dismiss: viewModel.dismissConfirmEventsView))
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingTransactions) {
            TeamTransactionsView(viewModel: TeamTransactionsViewModel(amt: .barTeam), showing: $viewModel.showingTransactions)
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingTopUp) {
            TopUpResidentView(viewModel: TopUpResidentViewModel(dismiss: viewModel.dismissDepositResident))
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingKitchenKeyBox) {
            KitchenKastenView(showing: $viewModel.showingKitchenKeyBox)
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
    
    private var createBarEventView: some View {
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
                Text("Create Bar Evening".localized)
                    .font(Font.system(size: 20, weight: .medium, design: .rounded))
                    .kerning(0.25)
                Spacer()
            }.padding()
                .frame(width: screen.width - 30)
            .background(Color.white)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
        .sheet(isPresented: $viewModel.calendarManager.showingAddView) {
            CalendarEntryAddView(viewModel: CalendarEntryAddViewModel(calendarManager: viewModel.calendarManager, category: viewModel.barEventCategory))
        }
    }
    
    private var confirmDeclineEventsView: some View {
        Button(action: viewModel.showConfirmEventsView) {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.HHG_DarkBlue)
                    .overlay(Image(systemName: "calendar.badge.exclamationmark")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15))
                    .padding(.trailing, 5)
                Spacer()
                Text("Confirm event".localized)
                    .font(Font.system(size: 20, weight: .medium, design: .rounded))
                    .kerning(0.25)
                Spacer()
            }.padding()
                .frame(width: screen.width - 30)
            .background(Color.white)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
    }
    
    private var topUpAccountView: some View {
        Button(action: viewModel.depositResident) {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.HHG_LightBlue)
                    .overlay(Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15))
                    .padding(.trailing, 5)
                Spacer()
                Text("Charge / debit account".localized)
                    .font(Font.system(size: 20, weight: .medium, design: .rounded))
                    .kerning(0.25)
                Spacer()
            }.padding()
                .frame(width: screen.width - 30)
            .background(Color.white)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
    }
    
    private var barteamTransactionsView: some View {
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
    
    private var kitchenKeyBoxView: some View {
        Button(action: viewModel.showKitchenBox) {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.brown)
                    .overlay(Image("keys")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15))
                    .padding(.trailing, 5)
                Spacer()
                Text("Kitchen key".localized)
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

struct BarteamView_Previews: PreviewProvider {
    static var previews: some View {
        BarteamView(viewModel: BarteamViewModel(calendarManager: .mock))
    }
}
