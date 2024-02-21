//
//  TopUpResidentView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 27.06.22.
//

import SwiftUI
import Combine

struct TopUpResidentView: View {
    
    @StateObject var viewModel: TopUpResidentViewModel
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }.offset(y: 50)
            VStack {
                quickSelectionView
                amountView
                Spacer()
                VStack {
                    if viewModel.receiver != nil && !viewModel.sendingRequest {
                        Button(action: viewModel.change, label: {
                            Text("Change".localized)
                                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                                .kerning(0.25)
                                .padding(.bottom, -15)
                        })
                    }
                    button
                }.padding(.bottom, 80)
                .offset(y: -self.keyboardHeightHelper.keyboardHeight)
            }.offset(y: 50)
        }.background(backgroundView)
        .customAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, description: viewModel.alertDescription, boxes: viewModel.alertBoxes)
        .subtileAlert(isShowing: $viewModel.showingSubtileAlert, title: viewModel.alertTitle, subtitle: viewModel.alertSubtitle, image: viewModel.alertImage, showingClose: false, specialPadding: 50)
    }
    
    //MARK: Subviews
    
    private var closeButton: some View {
        Button(action: viewModel.dismiss) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var button: some View {
        Button(action: viewModel.action) {
            HStack {
                Spacer()
                Text(viewModel.sendingRequest ? "" : viewModel.buttonText)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingRequest {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(width: 30, height: 30)
                                    .padding(.vertical)
                            } else {
                                Text("")
                            }
                        }
                    )
                Spacer()
            }
            .frame(width: viewModel.sendingRequest ? 60 : UIScreen.main.bounds.width - 30, height: 60)
        }.background(viewModel.receiver != nil && !viewModel.amountNonZero ? .gray : Color.HHG_Blue)
        .cornerRadius(viewModel.sendingRequest ? 50 : 15)
        .disabled(viewModel.receiver != nil && !viewModel.amountNonZero)
        .padding(.top, 20)
        .sheet(isPresented: $viewModel.showingReceiverSelectionView) {
            ReceiverSelectionView(viewModel: ResidentSelectionViewModel(selectedResident: $viewModel.receiver, dismiss: viewModel.dismissReceiverSelectionView))
        }
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
    
    private var quickSelectionView: some View {
        HStack {
            Button(action: { viewModel.selectAmount(10) }) {
                Text("10 EUR")
                    .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.green.opacity(0.2))
                    .clipShape(Capsule())
            }.buttonStyle(PlainButtonStyle())
            Button(action: { viewModel.selectAmount(20) }) {
                Text("20 EUR")
                    .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.green.opacity(0.2))
                    .clipShape(Capsule())
            }.buttonStyle(PlainButtonStyle())
            Button(action: { viewModel.selectAmount(50) }) {
                Text("50 EUR")
                    .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.green.opacity(0.2))
                    .clipShape(Capsule())
            }.buttonStyle(PlainButtonStyle())
        }.padding(.vertical)
    }
}

struct TopUpResidentView_Previews: PreviewProvider {
    static var previews: some View {
        TopUpResidentView(viewModel: TopUpResidentViewModel(dismiss: {}))
    }
}
