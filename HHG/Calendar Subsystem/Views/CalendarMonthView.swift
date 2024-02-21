//
//  CalendarMonthView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.09.21.
//  Copyright © 2021 Richard Pfannenstiel. All rights reserved.
//

import SwiftUI

struct CalendarMonthView: View {
    
    @Namespace var animation
    @StateObject var viewModel: CalendarElegantViewModel

    var body: some View {
        MonthlyCalendarView(calendarManager: viewModel.calendarManager)
            .theme(.init(primary: Color.HHG_Blue))
            .horizontal()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .customAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, description: viewModel.alertSubtitle, boxes: viewModel.alertBoxes)
            .subtileAlert(isShowing: $viewModel.showingSubtileAlert, title: viewModel.alertTitle, subtitle: viewModel.alertSubtitle, image: viewModel.alertImage, showingClose: false)
            .scaleView(frame: viewModel.frame, isPresented: $viewModel.showingDetail) {
                CalendarDetailView(viewModel: CalendarDetailViewModel(eventId: viewModel.selectedUpcomingEvent!.id), showing: $viewModel.showingDetail)
                    .onDisappear(perform: viewModel.showTabBar)
            } background: {
                VisualEffectView(effect: UIBlurEffect.init(style: .systemChromeMaterialLight))
            }
    }
}
