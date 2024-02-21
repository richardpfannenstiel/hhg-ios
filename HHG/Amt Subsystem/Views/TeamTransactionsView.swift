//
//  TeamTransactionsView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 26.06.22.
//

import SwiftUI

struct TeamTransactionsView: View {
    
    @StateObject var viewModel: TeamTransactionsViewModel
    @Binding var showing: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.bookings
                            .filter(viewModel.filter)
                            .sorted(by: viewModel.sort)) { booking in
                    Button(action: { viewModel.select(booking) }) {
                        BookingCellView(viewModel: BookingCellViewModel(booking: booking, amt: viewModel.amt))
                            .offset(x: -15)
                    }.buttonStyle(PlainButtonStyle())
                    
                }
            }.navigationTitle("Transactions".localized)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        closeButton
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        balance
                    }
                }
        }.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .refreshable {
                viewModel.reload()
            }
            .slideView(isPresented: $viewModel.showingBookingDetail) {
                BookingDetailView(viewModel: BookingDetailViewModel(booking: viewModel.selectedBooking ?? .mock, amt: viewModel.amt), showing: $viewModel.showingBookingDetail)
            } background: {
                Color.white
            }
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: { withAnimation { showing = false }}) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
        }
    }
    
    private var balance: some View {
        Text("\(String(format: "%.2f", viewModel.balance))€")
            .font(Font.system(size: 18, weight: .semibold, design: .rounded))
            .kerning(0.25)
            .foregroundColor(viewModel.balance > 0 ? .green : .red)
    }
}

struct TeamTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamTransactionsView(viewModel: TeamTransactionsViewModel(amt: .haussprecher), showing: .constant(true))
    }
}
