//
//  CalendarParticipantsListView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.04.22.
//

import SwiftUI

struct CalendarParticipantsListView: View {
    
    @StateObject var viewModel: CalendarParticipantsListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.participants
                            .filter(viewModel.filter)
                            .sorted(by: viewModel.sort)) { resident in
                    Button(action: { viewModel.select(resident) }) {
                        ResidentCellView(resident: resident)
                            .background(Color.white)
                            .frame(width: screen.width)
                    }.buttonStyle(PlainButtonStyle())
                }
            }.padding(.horizontal, -15)
            .navigationBarItems(leading: closeButton)
        }.searchable(text: $viewModel.searchText, placement:.navigationBarDrawer(displayMode: .always))
            .slideView(isPresented: $viewModel.showingDetailView) {
                ResidentDetailView(viewModel: ResidentDetailViewModel(resident: viewModel.selectedResident!), showing: $viewModel.showingDetailView)
            } background: {
                Color.white
            }
    }
    
    private var closeButton: some View {
        Button(action: viewModel.dismiss) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
        }
    }
}

struct CalendarParticipantsListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarParticipantsListView(viewModel: CalendarParticipantsListViewModel(participants: [.mock], dismiss: {}))
    }
}
