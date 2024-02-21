//
//  ChangeEmailView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 20.03.22.
//

import SwiftUI

struct ChangeEmailView: View {
    
    @StateObject var viewModel: ChangeEmailViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            Image(systemName: "envelope.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            Text("E-Mail".localized)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
            Text("If your email address has changed, you can update it here.".localized)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.horizontal)
            oldEmailView
            newEmailView
            newEmailRepeatedView
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
    
    private var oldEmailView: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .overlay(Image(systemName: "envelope.open.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 15, height: 15))
                .padding(.trailing, 5)
            Text(viewModel.oldMail)
                .foregroundColor(Color(#colorLiteral(red: 0.7685185075, green: 0.7685293555, blue: 0.7766974568, alpha: 1)))
                .padding(.horizontal)
            Spacer()
        }.padding()
            .frame(width: screen.width - 30)
        .background(Color.white)
        .cornerRadius(15)
    }
    
    private var newEmailView: some View {
        HStack {
            Image(systemName: "envelope.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            TextField("New mail".localized, text: $viewModel.newMail)
                .keyboardType(.emailAddress)
                .padding(.horizontal)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var newEmailRepeatedView: some View {
        HStack {
            Image(systemName: "envelope.circle.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            TextField("New mail repeated".localized, text: $viewModel.newMailRepeated)
                .keyboardType(.emailAddress)
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
                                if viewModel.changeEmailSuccessfully {
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
            .frame(width: viewModel.sendingRequest ? 60 : screen.width - 30, height: 60)
        }.background(viewModel.validParameters ? Color.HHG_Blue : Color.gray)
        .cornerRadius(viewModel.sendingRequest ? 50 : 15)
        .padding(.top, 20)
    }
}

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView(viewModel: ChangeEmailViewModel(dismiss: {}))
    }
}
