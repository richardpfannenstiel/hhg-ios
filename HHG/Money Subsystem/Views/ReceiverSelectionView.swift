//
//  ReceiverSelectionView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.03.22.
//

import SwiftUI

struct ReceiverSelectionView: View {
    
    @StateObject var viewModel: ResidentSelectionViewModel
    
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
            .navigationBarItems(leading: closeButton)
        }.searchable(text: $viewModel.searchText, placement:.navigationBarDrawer(displayMode: .always))
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

struct ReceiverSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverSelectionView(viewModel: ResidentSelectionViewModel(selectedResident: .constant(.mock), dismiss: {}))
    }
}
