//
//  ChangeResidentOrderView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.03.22.
//

import SwiftUI

struct ChangeResidentOrderView: View {
    
    @StateObject var viewModel: ChangeResidentOrderViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(.HHG_DarkBlue)
                .overlay(Image(systemName: "person.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white))
            Text("Resident".localized)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
            Text("The resident list can be sorted by first or last name.".localized)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.horizontal)
            sortingOrderRow
            displayFormatRow
            Spacer()
        }.background(backgroundView)
        .bottomSheet(isPresented: $viewModel.showingSortingOrderMenu, dismiss: viewModel.dismissSortingOrderMenu, height: 250) {
            sortingOrderSheet
        } background: {
            Color.white
        }
        .bottomSheet(isPresented: $viewModel.showingDisplayFormatMenu, dismiss: viewModel.dismissDisplayFormatMenu, height: 250) {
            displayFormatSheet
        } background: {
            Color.white
        }

    }
    
    private var sortingOrderSheet: some View {
        VStack {
            Text("Sorting".localized)
                .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                .kerning(0.25)
            Spacer()
            Button(action: { viewModel.selectSortingOrder(order: 0) }) {
                HStack {
                    Text("First name, last name".localized)
                    Spacer()
                    if viewModel.sortingOrder == 0 {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 30, height: 30)
                    }
                }.padding()
                .frame(width: screen.width - 100, height: 60)
                .background(cardBackground)
                .cornerRadius(15)
            }.buttonStyle(ScaleButtonStyle())
            Button(action: { viewModel.selectSortingOrder(order: 1) }) {
                HStack {
                    Text("Last, first name".localized)
                    Spacer()
                    if viewModel.sortingOrder == 1 {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 30, height: 30)
                    }
                }.padding()
                .frame(width: screen.width - 100, height: 60)
                .background(cardBackground)
                .cornerRadius(15)
            }.buttonStyle(ScaleButtonStyle())
        }.padding(.vertical)
    }
    
    private var displayFormatSheet: some View {
        VStack {
            Text("Display format".localized)
                .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                .kerning(0.25)
            Spacer()
            Button(action: { viewModel.selectDisplayFormat(format: 0) }) {
                HStack {
                    Text("First name, last name".localized)
                    Spacer()
                    if viewModel.displayFormat == 0 {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 30, height: 30)
                    }
                }.padding()
                .frame(width: screen.width - 100, height: 60)
                .background(cardBackground)
                .cornerRadius(15)
            }.buttonStyle(ScaleButtonStyle())
            Button(action: { viewModel.selectDisplayFormat(format: 1) }) {
                HStack {
                    Text("Last, first name".localized)
                    Spacer()
                    if viewModel.displayFormat == 1 {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 30, height: 30)
                    }
                }.padding()
                .frame(width: screen.width - 100, height: 60)
                .background(cardBackground)
                .cornerRadius(15)
            }.buttonStyle(ScaleButtonStyle())
        }.padding(.vertical)
    }
    
    private var cardBackground: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
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
    
    private var sortingOrderRow: some View {
        Button(action: viewModel.showSortingOrderMenu) {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.HHG_DarkBlue)
                    .overlay(Image(systemName: "arrow.up.arrow.down")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15))
                    .padding(.trailing, 5)
                Text("Sorting".localized)
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
                Spacer()
                Text("\(viewModel.sortingOrderString)")
                    .foregroundColor(Color(#colorLiteral(red: 0.7685185075, green: 0.7685293555, blue: 0.7766974568, alpha: 1)))
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
                    .padding(.horizontal)
            }.padding()
                .frame(width: screen.width - 30)
            .background(Color.white)
            .cornerRadius(15)
        }.buttonStyle(PlainButtonStyle())
    }
    
    private var displayFormatRow: some View {
        Button(action: viewModel.showDisplayFormatMenu) {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.HHG_DarkBlue)
                    .overlay(Image(systemName: "textformat")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15))
                    .padding(.trailing, 5)
                Text("Display format".localized)
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
                Spacer()
                Text("\(viewModel.displayFormatString)")
                    .foregroundColor(Color(#colorLiteral(red: 0.7685185075, green: 0.7685293555, blue: 0.7766974568, alpha: 1)))
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
                    .padding(.horizontal)
            }.padding()
                .frame(width: screen.width - 30)
            .background(Color.white)
            .cornerRadius(15)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ChangeResidentOrderView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeResidentOrderView(viewModel: ChangeResidentOrderViewModel(dismiss: {}))
    }
}
