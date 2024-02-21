//
//  CalendarDetailOptions.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 08.10.21.
//

import SwiftUI

struct CalendarDetailOptions: View {
    
    @StateObject var viewModel: CalendarDetailOptionsViewModel
    
    var body: some View {
        VStack {
            shareView
            if !(viewModel.event.startDate < Date()) {
                reminderView
            }
            if !viewModel.url.isEmpty {
                urlView
            }
        }.padding(.top, 50)
    }
    
    private var cardBackground: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }
    }
    
    private var reminderView: some View {
        Button(action: viewModel.remind) {
            HStack {
                Image(systemName: viewModel.notificationScheduled ? "bell.slash" : "bell")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text("Reminder".localized)
                        .bold()
                    Text(viewModel.notificationScheduled ? "abort".localized : "create".localized)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
                .frame(width: screen.width - 100, height: 60)
            .background(cardBackground)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
    }
    
    private var shareView: some View {
        Button(action: viewModel.share) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 25, height: 30)
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text("Share".localized)
                        .bold()
                    Text("Copy link".localized)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
            .frame(width: screen.width - 100, height: 60)
            .background(cardBackground)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
    }
    
    private var urlView: some View {
        Button(action: viewModel.openURL) {
            HStack {
                urlImage
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text(viewModel.urlTitle)
                        .bold()
                    Text(viewModel.urlDescription)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
            .frame(width: screen.width - 100, height: 60)
            .background(cardBackground)
            .cornerRadius(15)
        }.buttonStyle(ScaleButtonStyle())
    }
    
    private var urlImage: some View {
        if viewModel.url.contains("https://signal.group/") {
            return Image("signal")
                .resizable()
                .frame(width: 25, height: 25)
        }
        if viewModel.url.contains("https://chat.whatsapp.com/") {
            return Image("whatsapp")
                .resizable()
                .frame(width: 30, height: 30)
        }
        if viewModel.url.contains("https://t.me/") {
            return Image("telegram")
                .resizable()
                .frame(width: 25, height: 25)
        }
        return Image(systemName: "network")
            .resizable()
            .frame(width: 25, height: 25)
    }
}



/*struct CalendarDetailOptions_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .bottomSheet(isPresented: .constant(true), height: 300, content: {
                CalendarDetailOptions(viewModel: CalendarDetailOptionsViewModel(url: "https://chat.whatsapp.com/", event: CalendarEvent.mock))
            }, background: {
                Color.white
            }).edgesIgnoringSafeArea(.all)
        Text("")
            .bottomSheet(isPresented: .constant(true), height: 300, content: {
                CalendarDetailOptions(viewModel: CalendarDetailOptionsViewModel(url: "https://t.me/", event: CalendarEvent.mock))
            }, background: {
                Color.white
            }).edgesIgnoringSafeArea(.all)
        Text("")
            .bottomSheet(isPresented: .constant(true), height: 300, content: {
                CalendarDetailOptions(viewModel: CalendarDetailOptionsViewModel(url: "https://signal.group/", event: CalendarEvent.mock))
            }, background: {
                Color.white
            }).edgesIgnoringSafeArea(.all)
        Text("")
            .bottomSheet(isPresented: .constant(true), height: 300, content: {
                CalendarDetailOptions(viewModel: CalendarDetailOptionsViewModel(url: "https://hochschulhaus-garching.de", event: CalendarEvent.mock))
            }, background: {
                Color.white
            }).edgesIgnoringSafeArea(.all)
        Text("")
            .bottomSheet(isPresented: .constant(true), height: 230, content: {
                CalendarDetailOptions(viewModel: CalendarDetailOptionsViewModel(url: "", event: CalendarEvent.mock))
            }, background: {
                Color.white
            }).edgesIgnoringSafeArea(.all)
        
    }
}*/
