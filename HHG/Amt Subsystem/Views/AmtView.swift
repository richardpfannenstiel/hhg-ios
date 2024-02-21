//
//  AmtView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.03.22.
//

import SwiftUI

struct AmtView: View {
    
    @ObservedObject var calendarManager: MonthlyCalendarManager
    @StateObject var viewModel: AmtViewModel
    
    var body: some View {
        switch viewModel.bigAmt {
        case .admin:
            AdminView(viewModel: AdminViewModel(calendarManager: calendarManager))
        case .barTeam:
            BarteamView(viewModel: BarteamViewModel(calendarManager: calendarManager))
        case .haussprecher:
            HaussprecherView(viewModel: HaussprecherViewModel(calendarManager: calendarManager))
        case .tutor:
            TutorView(viewModel: TutorViewModel(calendarManager: calendarManager))
        default:
            DefaultAmtView()
        }
    }
}

struct AmtView_Previews: PreviewProvider {
    static var previews: some View {
        AmtView(calendarManager: .mock, viewModel: AmtViewModel())
    }
}
