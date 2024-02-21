//
//  TransactionView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.03.22.
//

import SwiftUI
import Combine

struct TransactionView: View {
    
    @StateObject var viewModel: TransactionViewModel
    
    var body: some View {
        ScrollView {
            HStack {
                closeButton
                Spacer()
            }
            VStack {
                transactionPartnersView
                amountView
                    .padding(.vertical)
                commentTextField
                payButtonView
                Spacer()
            }.padding(.horizontal)
            .sheet(isPresented: $viewModel.showingReceiverSelectionView) {
                ReceiverSelectionView(viewModel: ResidentSelectionViewModel(selectedResident: $viewModel.receiver, dismiss: viewModel.dismissReceiverSelectionView))
            }
        }.background(
            backgroundView
        ).ignoresSafeArea(.keyboard, edges: .bottom)
        .subtileAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, subtitle: viewModel.alertSubtitle, image: viewModel.alertImage, showingClose: false, specialPadding: 10)
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: viewModel.dismiss) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var transactionPartnersView: some View {
        HStack {
            if viewModel.receiver != nil {
                senderProfile
                VStack(alignment: .leading) {
                    Text(viewModel.sender.givenName)
                        .font(Font.system(size: 15, weight: .light, design: .rounded))
                        .kerning(0.25)
                    Text("\(String(format: "%.2f", BookingStore.shared.balance))€")
                        .font(Font.system(size: 15, weight: .light, design: .rounded))
                        .kerning(0.25)
                        .foregroundColor(.gray)
                }
                Spacer()
                directionArrow
                Spacer()
                Button(action: viewModel.showReceiverSelectionView) {
                    HStack {
                        receiverProfile
                        VStack(alignment: .leading) {
                            if let receiver = viewModel.receiver {
                                Text(receiver.givenName)
                                    .font(Font.system(size: 15, weight: .light, design: .rounded))
                                    .kerning(0.25)
                                Text(receiver.familyName)
                                    .font(Font.system(size: 15, weight: .light, design: .rounded))
                                    .kerning(0.25)
                            }
                        }
                    }
                }.buttonStyle(PlainButtonStyle())
            }
            
            if viewModel.receiver == nil {
                Spacer()
                ZStack {
                    receiverProfile
                        .opacity(0)
                    Button(action: viewModel.showReceiverSelectionView) {
                        Text("Select recipient".localized)
                            .font(Font.system(size: 17, weight: .light, design: .rounded))
                            .kerning(0.25)
                            .foregroundColor(.secondary)
                    }.buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
    }
    
    private var senderProfile: some View {
        Circle()
            .frame(width: 40, height: 40)
            .foregroundColor(Color.gray)
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(Text("\(String(viewModel.sender.givenName.first!))\(String(viewModel.sender.familyName.first!))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white))
    }
    
    private var receiverProfile: some View {
        if let receiver = viewModel.receiver {
            return AnyView(Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.gray)
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                .overlay(Text("\(String(receiver.givenName.first!))\(String(receiver.familyName.first!))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)))
        } else {
            return AnyView(Image(systemName: "person.fill")
                .resizable()
                .frame(width: 37, height: 37)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4)))
        }
    }
    
    private var directionArrow: some View {
        Image(systemName: "arrow.right.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
    }
    
    private var payButtonView: some View {
        Button(action: viewModel.send) {
            HStack {
                Spacer()
                Text(viewModel.sendingRequest ? "" : "Pay".localized)
                    .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingRequest {
                                if viewModel.moneyTransferredSuccessfully {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .padding(.vertical)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(width: 30, height: 30)
                                        .padding(.vertical)
                                }
                            } else {
                                Text("")
                            }
                        }
                    )
                Spacer()
            }
            .frame(width: viewModel.sendingRequest ? 60 : UIScreen.main.bounds.width - 30, height: 60)
        }.disabled(!viewModel.validParameters)
        .background(viewModel.validParameters ? Color.HHG_Blue : Color.gray)
        .cornerRadius(viewModel.sendingRequest ? 50 : 15)
        .padding(.top, 20)
    }
    
    private var commentTextField: some View {
        HStack {
            Image(systemName: "text.bubble.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(.trailing, 5)
            TextField("Add comment".localized, text: $viewModel.comment)
                .disabled(viewModel.sendingRequest)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
    }
    
    private var amountView: some View {
        VStack {
            Text("\((Double(viewModel.amount) ?? 0) / 100, specifier: "%.2f")")
                .font(Font.system(size: 60, weight: .bold, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .overlay(
                    NumberTextField(text: $viewModel.amount)
                        .frame(width: screen.width, height: 100, alignment: .center)
                        .disabled(viewModel.sendingRequest)
                        .ignoresSafeArea(.keyboard)
            
                )
            Text("EUR")
                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                .kerning(0.25)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(Color.HHG_LightBlue.opacity(0.2))
                .clipShape(Capsule())
                .padding(.top, -30)
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(viewModel: TransactionViewModel(dismiss: {}))
        TransactionView(viewModel: TransactionViewModel(receiver: .mock, dismiss: {}))
    }
}
