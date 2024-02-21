//
//  ContributionView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 03.04.22.
//

import SwiftUI

struct ContributionView: View {
    
    @StateObject var viewModel: ContributionViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    closeButton
                    Spacer()
                }
                Button(action: viewModel.love) {
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.red)
                        .overlay(Image(systemName: "heart.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40))
                }.buttonStyle(ScaleButtonStyle())
                Text("Contribution".localized)
                    .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                    .kerning(0.25)
                Text("The Hochschulhaus Garching app is a heartfelt project that was brought to life by (former 🥲) residents.".localized)
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                developers
            }.background(backgroundView)
            viewModel.confetti
                .offset(y: -200)
                .opacity(viewModel.animationPlaying ? 1 : 0)
        }
        
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
    
    private var developers: some View {
        VStack {
            HStack(spacing: 30) {
                VStack {
                    Circle()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .overlay(Image("nico")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 90, height: 90))
                        .clipShape(Circle())
                    Text("Nico")
                        .font(Font.system(size: 17, weight: .medium, design: .rounded))
                        .kerning(0.25)
                }
                VStack {
                    Circle()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .overlay(Image("marc")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 90, height: 90)
                                    .offset(y: 10))
                        .clipShape(Circle())
                    Text("Marc")
                        .font(Font.system(size: 17, weight: .medium, design: .rounded))
                        .kerning(0.25)
                }
                VStack {
                    Circle()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .overlay(Image("richard")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 80)
                                    .offset(y: 6))
                        .clipShape(Circle())
                    Text("Richard")
                        .font(Font.system(size: 17, weight: .medium, design: .rounded))
                        .kerning(0.25)
                }
            }.padding(.vertical)
            Text("For a continuous advancement, suggestions for improvement as well as talented iOS / Android developers are needed.\n\nThank you for your help!".localized)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            Button(action: viewModel.contribute) {
                HStack {
                    Text("I would like to help out myself".localized)
                        .font(Font.system(size: 17, weight: .regular, design: .rounded))
                        .kerning(0.25)
                    Spacer()
                    arrowView
                }.padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)
            }.buttonStyle(PlainButtonStyle())
            Button(action: viewModel.feedback) {
                HStack {
                    Text("I would like to leave feedback".localized)
                        .font(Font.system(size: 17, weight: .regular, design: .rounded))
                        .kerning(0.25)
                    Spacer()
                    arrowView
                }.padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)
            }.buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
    
    private var arrowView: some View {
        VStack {
            Spacer()
            Image(systemName: "chevron.right")
            Spacer()
        }.frame(height: 20)
    }
}

struct ContributionView_Previews: PreviewProvider {
    static var previews: some View {
        ContributionView(viewModel: ContributionViewModel(dismiss: {}))
    }
}
