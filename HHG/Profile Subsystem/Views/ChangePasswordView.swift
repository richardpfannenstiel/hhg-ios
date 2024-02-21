//
//  ChangePasswordView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 08.03.22.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject var viewModel: ChangePasswordViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(.gray)
                .overlay(Image("keys")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50))
            Text("Password".localized)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
            Text("It is recommended to change the password regularly. Choosing a long and complex text increases security.".localized)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.horizontal)
            oldPasswordView
            newPasswordView
            newPasswordRepeatedView
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
    
    private var oldPasswordView: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
                .overlay(Image(systemName: "lock.open.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 15, height: 15))
                .padding(.trailing, 5)
            SecureField("Old password".localized, text: $viewModel.oldPassword)
                .padding(.horizontal)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var newPasswordView: some View {
        HStack {
            Image(systemName: "lock.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            SecureField("New password".localized, text: $viewModel.newPassword)
                .padding(.horizontal)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var newPasswordRepeatedView: some View {
        HStack {
            Image(systemName: "lock.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            SecureField("New password repeated".localized, text: $viewModel.newPasswordRepeated)
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
                Text(viewModel.sendingRequest ? "" : "Apply".localized)
                    .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingRequest {
                                if viewModel.changePasswordSuccessfully {
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

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(viewModel: ChangePasswordViewModel(dismiss: {}))
    }
}
