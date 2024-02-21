//
//  HomeView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.08.21.
//

import SwiftUI

struct HomeView: View {
    
    var animation: Namespace.ID
    
    //@StateObject var viewModel: HomeViewModel
    
    @State var showingSheet = false
    
    var body: some View {
        /*NavigationView {
            SwiftUI.ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(CalendarCard.cards) { card in
                        Button(action: { buttonTap(card: card) }) {
                            CardView(card: card)
                                .padding()
                                /*.background(
                                    cardBG(card: card)
                                )*/
                                .foregroundColor(.black)
                        }.buttonStyle(CalendarCardButtonStyle())
                    }
                }.padding()
            }.overlay(
                CalendarDetailView(viewModel: viewModel, animation: animation)
            ).navigationBarHidden(true)
        }*/
        Text("")
    }
    
    /*func buttonTap(card: CalendarCard) {
        withAnimation(.spring()) {
            viewModel.currentCalendarCard = card
            viewModel.showingDetail = true
            viewModel.setHeader(bool: false)
            viewModel.setTabBar(bool: false)
        }
    }
    
    @ViewBuilder
    func cardBG(card: CalendarCard) -> some View {
        ZStack {
            if viewModel.showingDetail && viewModel.currentCalendarCard == card {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .cornerRadius(15)
                    .opacity(0)
            } else {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .cornerRadius(15)
                    .matchedGeometryEffect(id: card.id + "BG", in: animation)
            }
        }
    }
    
    @ViewBuilder
    func CardView(card: CalendarCard) -> some View {
        VStack {
            
            if viewModel.showingDetail && viewModel.currentCalendarCard == card {
                Image(card.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom)
                    .opacity(0)
                Text(card.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(0)
            } else {
                Image(card.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: card.id + "IMAGE", in: animation)
                    .padding(.bottom)
                Text(card.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .matchedGeometryEffect(id: card.id + "TITLE", in: animation)
            }
        }
    }*/
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
