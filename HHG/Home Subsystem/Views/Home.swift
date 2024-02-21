//
//  Home.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 15.09.21.
//

import SwiftUI

struct Home: View {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @Namespace var animation
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            backgroundColor
            scrollView
            logo
                .frame(width: viewModel.iconSize, height: viewModel.iconSize)
                .rotationEffect(.init(degrees: viewModel.iconRotation))
                .offset(x: viewModel.iconOffsetX, y: viewModel.iconOffsetY)
                //.animation(.default, value: 1)
            HomeGreetingsView(greeting: viewModel.greeting, name: viewModel.userName)
                .opacity(viewModel.logoAnimation ? viewModel.headerOpacity : 0)
            HomeProfileIconView(action: viewModel.showProfileMenuView)
                .opacity(viewModel.logoAnimation ? viewModel.headerOpacity : 0)
        }.bottomSheet(isPresented: $viewModel.showingProfileMenu, dismiss: viewModel.dismissProfileMenuView, height: 450, content: {
            MenuView(viewModel: MenuViewModel(dismiss: viewModel.dismissProfileMenuView))
        }, background: {
            Color.white
        })
        .scaleView(frame: viewModel.frame, isPresented: $viewModel.showingDetail) {
            CalendarDetailView(viewModel: CalendarDetailViewModel(eventId: viewModel.selectedUpcomingEvent!.id), showing: $viewModel.showingDetail)
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            VisualEffectView(effect: UIBlurEffect.init(style: .systemChromeMaterialLight))
        }
        .fullScreenCover(isPresented: $viewModel.showingNotificationsConfigure) {
            RequestNotificationView(viewModel: RequestNotificationViewModel(action: viewModel.animate))
                .preferredColorScheme(.light)
        }
        .slideView(isPresented: $viewModel.showingDepositView) {
            DepositView(showing: $viewModel.showingDepositView)
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingTransactionsView) {
            BookingListView(showing: $viewModel.showingTransactionsView)
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingKitchenBoxView) {
            KitchenKastenView(showing: $viewModel.showingKitchenBoxView)
                .onDisappear(perform: viewModel.showTabBar)
        } background: {
            Color.white
        }
    }
    
    private var backgroundColor: some View {
        Color.HHG_Blue
            .edgesIgnoringSafeArea(.all)
    }
    
    private var logo: some View {
        Image("hhg_icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private var upcomingEvents: some View {
        VStack {
            ForEach(viewModel.upcomingEvents) { event in
                Button(action: { viewModel.showCalendarDetailView(event: event) }, label: {
                    SmallCalendarCardView(event: event, animation: animation)
                }).buttonStyle(ScaleButtonStyle())
            }
            Spacer()
        }.frame(width: width)
        .padding(.top, 50)
    }
    
    private var kitchenReservation: some View {
        Button(action: viewModel.showKitchenBoxView) {
            KitchenKastenCellView(event: viewModel.kitchenReservationEvent ?? .mock)
        }.buttonStyle(PlainButtonStyle())
    }
    
    private var adaptableBackground: some View {
        ZStack(alignment: .bottom) {
            Color.HHG_Blue
            ZStack {
                Color.white
                Color.secondary.opacity(0.2)
            }.frame(height: viewModel.backgroundOffset)
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    private var scrollView: some View {
        ScrollView(axes: [.vertical],
                   showsIndicators: false,
                   offsetChanged: { viewModel.scrollOffset = $0.y }
        ){
            
            VStack {
                if viewModel.kitchenReservationEvent != nil {
                    kitchenReservation
                }
                BalanceView(viewModel: BalanceViewModel(topUpAction: viewModel.showDepositView, sendMoneyAction: viewModel.showSendMoneyView, showTransactionsAction: viewModel.showTransactionsView))
            }.padding(.top, 120)
                .scaleEffect(viewModel.logoAnimation ? 1 : 1.6)
                .opacity(viewModel.logoAnimation ? 1 : 0)
                .sheet(isPresented: $viewModel.showingSendMoneyView) {
                    TransactionView(viewModel: TransactionViewModel(dismiss: viewModel.dismissSendMoneyView))
                }
            
            ZStack(alignment: .top) {
                Color.white
                Color.secondary.opacity(0.2)
                VStack {
                    HomeCurve()
                        .foregroundColor(.HHG_Blue)
                        .frame(width: width, height: 70)
                    ZStack {
                        Color.white
                        Color.secondary.opacity(0.2)
                    }.frame(height: height / 3)
                }
                
                upcomingEvents
            }.offset(y: viewModel.logoAnimation ? 0 : height / 2)
            Spacer()
        }.background(
            adaptableBackground
        )
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewModel: HomeViewModel())
    }
}
