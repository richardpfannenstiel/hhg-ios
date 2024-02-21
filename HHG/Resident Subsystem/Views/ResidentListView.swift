//
//  ResidentListView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import SwiftUI

struct ResidentListView: View {
    
    @StateObject var viewModel = ResidentListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.residents
                            .filter(viewModel.filter)
                            .sorted(by: viewModel.sort)) { resident in
                    Button(action: { viewModel.select(resident) }) {
                        ResidentCellView(resident: resident)
                            .background(Color.white)
                            .frame(width: screen.width)
                    }.buttonStyle(PlainButtonStyle())
                    
                }
            }.padding(.horizontal, -15)
            .navigationBarTitle("Bewohner")
        }.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .slideView(isPresented: $viewModel.showingResident) {
            ResidentDetailView(viewModel: ResidentDetailViewModel(resident: viewModel.selectedResident!), showing: $viewModel.showingResident)
        } background: {
            Color.white
        }
    }
}

struct ResidentListView_Previews: PreviewProvider {
    static var previews: some View {
        ResidentListView()
    }
}
