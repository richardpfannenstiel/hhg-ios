//
//  DefaultAmtView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.07.22.
//

import SwiftUI

struct DefaultAmtView: View {
    
    @StateObject var viewModel = DefaultAmtViewModel()
    
    var body: some View {
        VStack {
            Text("Ämter".localized)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
                .padding(.top)
            Text(viewModel.description)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.horizontal)
            Spacer()
            aemter
                .sheet(isPresented: $viewModel.showingAmtDetails) {
                    AmtDetailView(showing: $viewModel.showingAmtDetails, amt: viewModel.selectedAmt!)
                }
            Spacer()
        }.frame(width: screen.width)
        .background(backgroundView)
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var aemter: some View {
        SwiftUI.ScrollView {
            ForEach(Amt.allCases) { amt in
                if ![viewModel.amt, .bank, .hausverwaltung, .resident].contains(amt) {
                    Button(action: { viewModel.show(amt) }) {
                        HStack {
                            amt.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 5)
                            Spacer()
                            Text(amt.rawValue)
                                .font(Font.system(size: 20, weight: .medium, design: .rounded))
                                .kerning(0.25)
                            Spacer()
                        }.padding()
                            .frame(width: screen.width - 30)
                        .background(Color.white)
                        .cornerRadius(15)
                    }.buttonStyle(ScaleButtonStyle())
                }
            }.padding(.bottom, 50)
        }
    }
}

struct DefaultAmtView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultAmtView()
    }
}
