//
//  BalanceView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 17.09.21.
//

import SwiftUI
import Combine

struct BalanceView: View {
    
    @StateObject var viewModel: BalanceViewModel
    
    var body: some View {
        VStack {
            currentBalanceView
            HStack {
                topUpButton
                sendMoneyButton
                Spacer()
            }.padding(.vertical, 10)
            if let lastTransaction = viewModel.lastTransaction {
                HStack {
                    Text("Last Transaction".localized)
                        .foregroundColor(.secondary)
                        .font(Font.system(size: 15, weight: .light, design: .rounded))
                        .kerning(0.25)
                    Spacer()
                    Button(action: viewModel.showTransactionsAction) {
                        Text("All Transactions".localized)
                            .foregroundColor(.HHG_Blue)
                            .font(Font.system(size: 15, weight: .light, design: .rounded))
                            .kerning(0.25)
                    }.buttonStyle(PlainButtonStyle())
                }
                Divider()
                BookingCellView(viewModel: BookingCellViewModel(booking: lastTransaction))
            }
        }.padding()
        .background(Color.white)
        .frame(width: viewModel.width - 30)
        .cornerRadius(10)
    }
    
    private var currentBalanceView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(String(format: "%.2f", viewModel.balance))€")
                    .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                Text("Balance".localized)
                    .font(Font.system(size: 15, weight: .light, design: .rounded))
                    .kerning(0.25)
            }
            Spacer()
        }
    }
    
    private var topUpButton: some View {
        Button(action: viewModel.topUpAction, label: {
            HStack {
                Image(systemName: "plus")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 10, height: 10)
                Text("Top up".localized)
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
            }.padding(.horizontal, 15)
            .padding(.vertical, 8)
            .foregroundColor(.HHG_DarkestBlue)
            .background(Color.HHG_LightBlue.opacity(0.2))
            .cornerRadius(8)
        }).buttonStyle(PlainButtonStyle())
    }
    
    private var sendMoneyButton: some View {
        Button(action: viewModel.sendMoneyAction, label: {
            HStack {
                Image(systemName: "arrow.right")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 10, height: 10)
                Text("Send money".localized)
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
            }.padding(.horizontal, 15)
            .padding(.vertical, 8)
            .foregroundColor(.HHG_DarkestBlue)
            .background(Color.HHG_LightBlue.opacity(0.2))
            .cornerRadius(8)
        }).buttonStyle(PlainButtonStyle())
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView(viewModel: BalanceViewModel(topUpAction: {}, sendMoneyAction: {}, showTransactionsAction: {}))
            .background(Color.HHG_Blue)
    }
}
