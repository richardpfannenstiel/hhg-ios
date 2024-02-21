//
//  ChangePhoneView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.03.22.
//

import SwiftUI

struct ChangePhoneView: View {
    
    @StateObject var viewModel: ChangePhoneViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            Image(systemName: "phone.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            Text("Phone".localized)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
            Text("If your phone number has changed, you can update it here.".localized)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.horizontal)
            oldPhoneView
            newPhoneView
            newPhoneViewRepeated
            updateButton
            Spacer()
        }.background(backgroundView)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .customAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, description: viewModel.alertDescription, boxes: viewModel.alertBoxes)
        .subtileAlert(isShowing: $viewModel.showingSubtileAlert, title: viewModel.alertTitle, subtitle: viewModel.alertDescription, image: viewModel.alertImage, showingClose: false, specialPadding: 10)
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: viewModel.dismiss) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var oldPhoneView: some View {
        HStack {
            Image(systemName: "phone.down.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(viewModel.oldPhone)
                .foregroundColor(Color(#colorLiteral(red: 0.7685185075, green: 0.7685293555, blue: 0.7766974568, alpha: 1)))
                .padding(.horizontal)
            Spacer()
        }.padding()
            .frame(width: screen.width - 30)
        .background(Color.white)
        .cornerRadius(15)
    }
    
    private var newPhoneView: some View {
        HStack {
            Image(systemName: "phone.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            DoneButtonTextField(text: $viewModel.newPhone, keyType: UIKeyboardType.phonePad, placeholder: "New number".localized)
                .frame(height: 20)
                .padding(.horizontal)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var newPhoneViewRepeated: some View {
        HStack {
            Image(systemName: "phone.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            DoneButtonTextField(text: $viewModel.newPhoneRepeated, keyType: UIKeyboardType.phonePad, placeholder: "New number repeated".localized)
                .frame(height: 20)
                .padding(.horizontal)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var updateButton: some View {
        Button(action: viewModel.update) {
            HStack {
                Spacer()
                Text(viewModel.sendingRequest ? "" : "Apply")
                    .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingRequest {
                                if viewModel.changePhoneSuccessfully {
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
        }.background(viewModel.validParameters ? Color.HHG_Blue : Color.gray)
        .cornerRadius(viewModel.sendingRequest ? 50 : 15)
        .padding(.top, 20)
    }
}

struct ChangePhoneView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePhoneView(viewModel: ChangePhoneViewModel(dismiss: {}))
    }
}
