//
//  KitchenKastenView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 21.06.22.
//

import SwiftUI

struct KitchenKastenView: View {
    
    @StateObject var viewModel = KitchenKastenViewModel()
    @Binding var showing: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    closeButton
                    Spacer()
                }.offset(y: 50)
                VStack {
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.brown)
                        .overlay(Image("keys")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40))
                    Text("Kitchen key".localized)
                        .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                        .kerning(0.25)
                    
                    Text("To open the key box, you must be near it.".localized)
                        .font(Font.system(size: 17, weight: .regular, design: .rounded))
                        .kerning(0.25)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    HStack {
                        viewModel.liveImage
                            .frame(width: 30)
                            .padding(.trailing, -5)
                        Text("\(viewModel.boxIsConnected ? "Connected".localized : "Offline")")
                            .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                            .kerning(0.25)
                            .foregroundColor(.red)
                    }.frame(height: 30)
                    viewModel.boxImage
                        .frame(width: screen.width)
                        .overlay(
                            Circle()
                                .foregroundColor(viewModel.boxLedColor)
                                .frame(width: 30)
                                .offset(x: 100, y: 100)
                        )
                }.offset(y: 50)
                Spacer()
                openButton
                    .padding(.top, 80)
                    .padding(.bottom, 30)
            }.padding(.horizontal)
                .onAppear(perform: viewModel.connect)
                .onDisappear(perform: viewModel.disconnect)
        }.background(
            backgroundView
        ).subtileAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, subtitle: viewModel.alertSubtitle, image: viewModel.alertImage, showingClose: false)
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: { withAnimation { showing = false } }) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var openButton: some View {
        Button(action: viewModel.open) {
            HStack {
                Spacer()
                Text(viewModel.sendingOpenRequest ? "" : "Open box".localized)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingOpenRequest {
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
            .frame(width: viewModel.sendingOpenRequest ? 60 : UIScreen.main.bounds.width - 30, height: 60)
        }.background((!viewModel.boxIsConnected || viewModel.boxIsOpen) ? Color.gray : Color.HHG_Blue)
        .disabled(!viewModel.boxIsConnected || viewModel.boxIsOpen)
        .cornerRadius(viewModel.sendingOpenRequest ? 50 : 15)
        .padding(.top, 20)
    }
}

struct KitchenKastenView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenKastenView(showing: .constant(true))
    }
}
