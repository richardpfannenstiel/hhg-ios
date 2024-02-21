//
//  ConfirmDeclineEventsView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import SwiftUI

struct ConfirmDeclineEventsView: View {
    
    @StateObject var viewModel: ConfirmDeclineEventsViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }.offset(y: 50)
            VStack {
                Text("Events".localized)
                    .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                Text("Confirm or reject planned events.".localized)
                    .font(Font.system(size: 15, weight: .light, design: .rounded))
                    .kerning(0.25)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }.offset(y: 50)
            unconfirmedEvents
                .padding(.top, 80)
                .padding(.bottom, 30)
            Spacer()
        }.background(backgroundView)
        .customAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, description: viewModel.alertDescription, boxes: viewModel.alertBoxes)
        .subtileAlert(isShowing: $viewModel.showingSubtileAlert, title: viewModel.alertTitle, subtitle: viewModel.alertDescription, image: viewModel.alertImage, showingClose: false, specialPadding: 50)
    }
    
    private var closeButton: some View {
        Button(action: viewModel.dismiss) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var unconfirmedEvents: some View {
        SwiftUI.ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.unconfirmedEvents) { event in
                    UnconfirmedCalendarCardView(event: event, action: viewModel.select)
                        .padding(.horizontal)
                }
            }.frame(width: screen.width - 30)
            .padding(.vertical)
        }.refreshable {
            print("")
        }
    }
}

struct ConfirmDeclineEventsView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmDeclineEventsView(viewModel: ConfirmDeclineEventsViewModel(dismiss: {}))
    }
}
