//
//  BookingListView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 28.02.22.
//

import SwiftUI

struct BookingListView: View {
    
    @StateObject var viewModel = BookingListViewModel()
    @Binding var showing: Bool
    
    var body: some View {
        NavigationView {
            List {
                quickSelectionView
                ForEach(viewModel.bookings
                            .filter(viewModel.filter)
                            .sorted(by: viewModel.sort)) { booking in
                    Button(action: { viewModel.select(booking) }) {
                        BookingCellView(viewModel: BookingCellViewModel(booking: booking))
                            .offset(x: -15)
                    }.buttonStyle(PlainButtonStyle())
                    
                }
            }.navigationTitle("Transactions".localized)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        closeButton
                    }
                }
        }.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .refreshable {
                viewModel.store.reload()
            }
            .slideView(isPresented: $viewModel.showingBookingDetail) {
                BookingDetailView(viewModel: BookingDetailViewModel(booking: viewModel.selectedBooking ?? .mock), showing: $viewModel.showingBookingDetail)
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
    
    private var quickSelectionView: some View {
        HStack {
            Button(action: { viewModel.toggleQuickSelection(selection: .bar) }, label: {
                VStack {
                    Image("team_bar")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                        .saturation(viewModel.showBarTransactions ? 1.0 : 0.0)
                    Text("Bar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }).buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: { viewModel.toggleQuickSelection(selection: .tutor) }, label: {
                VStack {
                    Image("team_tutor")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                        .saturation(viewModel.showTutorTransactions ? 1.0 : 0.0)
                    Text("Tutors".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }).buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: { viewModel.toggleQuickSelection(selection: .printer) }, label: {
                VStack {
                    Image("team_admin")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                        .saturation(viewModel.showPrinterTransactions ? 1.0 : 0.0)
                    Text("Printer".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }).buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: { viewModel.toggleQuickSelection(selection: .resident) }, label: {
                VStack {
                    Image("user")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                        .saturation(viewModel.showPrivateTransactions ? 1.0 : 0.0)
                    Text("Resident".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }).buttonStyle(PlainButtonStyle())
                .foregroundColor(.HHG_Blue)
        }.padding(.top)
    }
}

struct BookingListView_Previews: PreviewProvider {
    static var previews: some View {
        BookingListView(showing: .constant(true))
    }
}
