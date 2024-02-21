//
//  DeviceRegisterView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.03.22.
//

import SwiftUI
import Combine

struct DeviceRegisterView: View {
    
    @StateObject var viewModel: DeviceRegisterViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            macView
            descriptionView
            addButton
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
            ForEach(0 ..< 6) { index in
                ForEach(0 ..< 2) { subdex in
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 15, height: 30)
                        .background(RoundedRectangle(cornerRadius: 3).stroke(Color.HHG_Blue,lineWidth: 1))
                        .overlay(
                            Text("\(viewModel.mac.count > index*2 + subdex ? viewModel.mac[index*2 + subdex].uppercased() : "")")
                        )
                }
                if index < 5 {
                    Text(":")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.all, -3)
                }
            }
        }.overlay(
            TextField("", text: $viewModel.mac)
                .frame(height: 50)
                .foregroundColor(.clear)
                .accentColor(Color.clear)
                .onReceive(Just(viewModel.mac)) { newValue in
                    let filtered = newValue.uppercased().filter { "0123456789ABCDEF".contains($0) }
                    if newValue != filtered {
                        viewModel.mac = filtered
                    }
                    if newValue.count > 12 {
                        viewModel.mac = String(newValue.dropLast())
                    }
                }
        ).padding()
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
    
    private var addButton: some View {
        Button(action: viewModel.update) {
            HStack {
                Spacer()
                Text(viewModel.sendingRequest ? "" : "Add".localized)
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
}

struct DeviceRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRegisterView(viewModel: DeviceRegisterViewModel(dismiss: {}, reload: {}))
    }
}
