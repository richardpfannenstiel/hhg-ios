//
//  BookingCellView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.02.22.
//

import SwiftUI

struct BookingCellView: View {
    
    @StateObject var viewModel: BookingCellViewModel
    
    var body: some View {
        VStack {
            HStack {
                viewModel.previewPicture
                    .padding(.trailing, 5)
                partnerNameView
                Spacer()
                VStack(alignment: .trailing) {
                    amountView
                }.padding(.trailing, 10)
            }
            .padding(.all, 10)
        }.frame(width: screen.width - 30)
    }
    
    private var partnerNameView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.bookingPartnerName)
                .font(Font.system(size: 16, weight: .medium, design: .rounded))
                .kerning(0.25)
            Text(viewModel.booking.comment)
                .foregroundColor(.gray)
                .font(Font.system(size: 15, weight: .light, design: .rounded))
                .kerning(0.25)
        }
    }
    
    private var amountView: some View {
        Text(viewModel.amount)
            .foregroundColor(viewModel.bookingValue == .credit ? .red : .green)
            .font(Font.system(size: 16, weight: .light, design: .rounded))
            .kerning(0.25)
    }
}

struct BookingCellView_Previews: PreviewProvider {
    static var previews: some View {
        BookingCellView(viewModel: BookingCellViewModel(booking: .mock))
    }
}
