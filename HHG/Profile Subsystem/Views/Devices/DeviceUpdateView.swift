//
//  DeviceRegisterView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.03.22.
//

import SwiftUI
import Combine

struct DeviceUpdateView: View {
    
    @StateObject var viewModel: DeviceUpdateViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            macView
            descriptionView
            if !viewModel.sendingDeleteRequest {
                updateButton
            }
            if !viewModel.sendingRequest {
                deleteButtonView
            }
            Spacer()
        }.background(backgroundView)
        .subtileAlert(isShowing: $viewModel.showingSubtileAlert, title: viewModel.alertTitle, subtitle: viewModel.alertDescription, image: viewModel.alertImage, showingClose: false, specialPadding: 10)
        .foregroundColor(.black)
        .customAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, description: viewModel.alertDescription, boxes: viewModel.alertBoxes)
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
    
    private var macView: some View {
        HStack {
            Text(viewModel.device.mac)
                .foregroundColor(Color(#colorLiteral(red: 0.7685185075, green: 0.7685293555, blue: 0.7766974568, alpha: 1)))
            Spacer()
        }.padding()
        .frame(width: screen.width - 30, height: 60)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    
    private var descriptionView: some View {
        TextField("Description".localized, text: $viewModel.description)
            .padding()
            .frame(width: screen.width - 30, height: 60)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal)
    }
    
    private var updateButton: some View {
        Button(action: viewModel.update) {
            HStack {
                Spacer()
                Text(viewModel.sendingRequest ? "" : "Update".localized)
                    .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingRequest {
                                if viewModel.addDeviceSuccessfully {
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
    
    private var deleteButtonView: some View {
        Button(action: viewModel.delete) {
            HStack {
                Spacer()
                Text(viewModel.sendingDeleteRequest ? "" : "Delete".localized)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingDeleteRequest {
                                if viewModel.deleteDeviceSuccessfully {
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
            .frame(width: viewModel.sendingDeleteRequest ? 60 : UIScreen.main.bounds.width - 30, height: 60)
        }.background(Color.red)
        .cornerRadius(viewModel.sendingDeleteRequest ? 50 : 15)
        .padding(.top, 5)
    }
}

struct DeviceUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceUpdateView(viewModel: DeviceUpdateViewModel(dismiss: {}, reload: {}, device: .mock))
    }
}
