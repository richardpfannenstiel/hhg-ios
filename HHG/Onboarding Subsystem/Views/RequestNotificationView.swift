//
//  RequestNotificationView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.10.21.
//

import SwiftUI

struct RequestNotificationView: View {
    
    @StateObject var viewModel: RequestNotificationViewModel
    
    var body: some View {
        VStack {
            Text("Notifications".localized)
                .font(Font.system(size: 40, weight: .bold, design: .rounded))
                .kerning(0.25)
            Spacer()
            Image("notifications")
                .resizable()
                .scaledToFit()
                .frame(width: viewModel.width / 2)
            Spacer()
            descriptionView
            Spacer()
            requestButton
        }.padding(.top, 50)
        .padding(.bottom)
    }
    
    private var requestButton: some View {
        Button(action: viewModel.configure) {
            Text("Configure".localized)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: viewModel.width - 30, height: 60)
        }
        .background(Color.HHG_Blue)
        .cornerRadius(15)
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "creditcard.circle")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("Transactions".localized)
                    Text("Always be informed when you have received money or your account has been debited.".localized)
                        .foregroundColor(.secondary)
                }
            }
            HStack {
                Image(systemName: "calendar.circle")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("Calendar entries".localized)
                    Text("Receive notifications about upcoming dorm activities.".localized)
                        .foregroundColor(.secondary)
                }
            }
        }.frame(width: viewModel.width - 45)
    }
}

struct RequestNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        RequestNotificationView(viewModel: RequestNotificationViewModel(action: {}))
    }
}
