//
//  BookingDetailView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 28.02.22.
//

import SwiftUI

struct BookingDetailView: View {
    
    @AppStorage("user.id") var userID = ""
    @StateObject var viewModel: BookingDetailViewModel
    
    @Binding var showing: Bool
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    closeButton
                    Spacer()
                }.offset(y: 50)
                viewModel.previewPicture
                    .padding(.top, 50)
                sentText
                    .padding()
                if viewModel.beverages.isEmpty {
                    Divider().frame(width: 100)
                    commentView
                        .padding(.horizontal)
                } else {
                    Divider().frame(width: 100)
                    beveragesView
                        .padding()
                    Divider().frame(width: 100)
                }
                dateView
                    .padding(.top)
                actionsView
                Spacer()
                transactionDetails
            }.padding(.horizontal)
        }.background(
            backgroundView
        )
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: { withAnimation { showing = false }}) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }
    }
    
    private var dateView: some View {
        HStack {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text("Transaction executed on".localized)
                    .font(Font.system(size: 18, weight: .light, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.secondary)
                HStack(alignment: .center) {
                    Text("\(viewModel.bookingDate.dayAndDate)")
                        .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                        .kerning(0.25)
                    Text("\(viewModel.bookingDate.detailedTime)")
                        .font(Font.system(size: 18, weight: .light, design: .rounded))
                        .kerning(0.25)
                }
            }
            Spacer(minLength: 0)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
    }
    
    private var sentText: some View {
            (Text(viewModel.sentTextPrefix)
                .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                .kerning(0.25) +
             Text(" \(String(format: "%.2f", abs(viewModel.booking.amount)))€ ")
                .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                .kerning(0.25)
                .foregroundColor(viewModel.bookingValue == .credit ? .red : .green) +
             Text(viewModel.sentTextSuffix)
                .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                .kerning(0.25))
                .multilineTextAlignment(.center)
    }
    
    private var transactionDetails: some View {
        Text("Transaction ID: \(viewModel.booking.timestamp)".localized)
            .font(Font.system(size: 12, weight: .light, design: .rounded))
            .kerning(0.25)
            .padding(.bottom, 20)
    }
    
    private var sendMoneyButton: some View {
        Button(action: viewModel.showMoneyTransfer, label: {
            HStack {
                Image(systemName: "paperplane.fill")
                Text("Send money".localized)
                    .font(Font.system(size: 17, weight: .light, design: .rounded))
                    .kerning(0.25)
            }.padding()
            .frame(width: (screen.width - 45) / 2)
            .background(viewModel.bookingPartner == nil ? Color.gray : Color.HHG_Blue)
            .cornerRadius(15)
            .sheet(isPresented: $viewModel.showingMoneyTransferView) {
                TransactionView(viewModel: TransactionViewModel(receiver: viewModel.bookingPartner as! Resident, dismiss: viewModel.dismissMoneyTransfer))
                    .foregroundColor(.black)
            }
        }).buttonStyle(ScaleButtonStyle())
    }
    
    private var contactButton: some View {
        Button(action: viewModel.showResidentView, label: {
            HStack {
                Image(systemName: "envelope.fill")
                Text("Contact".localized)
                    .font(Font.system(size: 17, weight: .light, design: .rounded))
                    .kerning(0.25)
            }.padding()
            .frame(width: (screen.width - 45) / 2)
            .background(viewModel.bookingPartner == nil ? Color.gray : Color.HHG_DarkBlue)
            .cornerRadius(15)
            .sheet(isPresented: $viewModel.showingResidentView) {
                ResidentDetailView(viewModel: ResidentDetailViewModel(resident: viewModel.bookingPartner as! Resident), showing: $viewModel.showingResidentView)
                    .foregroundColor(.black)
            }

        }).buttonStyle(ScaleButtonStyle())
    }
    
    private var actionsView: some View {
        if viewModel.booking.type == .resident {
            return AnyView(HStack(spacing: 15) {
                contactButton
                    .disabled(viewModel.bookingPartner == nil)
                sendMoneyButton
                    .disabled(viewModel.bookingPartner == nil)
            }.foregroundColor(.white)
            .padding())
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private var commentView: some View {
        Text("\(viewModel.booking.comment)")
            .font(Font.system(size: 18, weight: .semibold, design: .rounded))
            .kerning(0.25)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
    }
    
    private var beveragesView: some View {
        HStack {
            TabView {
                if let softdrinks = viewModel.beverages["softdrink"] {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .overlay(Image("softdrink")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40))
                        VStack(alignment: .leading) {
                            Text("Softdrink:")
                                .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                .kerning(0.25)
                            striche(number: Int(softdrinks[0]), price: softdrinks[1])
                        }.padding(.leading, 5)
                        
                        Spacer()
                    }
                }
                if let beer = viewModel.beverages["beer"] {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .overlay(Image("beer")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40))
                        VStack(alignment: .leading) {
                            Text("Beer:".localized)
                                .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                .kerning(0.25)
                            striche(number: Int(beer[0]), price: beer[1])
                        }.padding(.leading, 5)
                        Spacer()
                    }
                }
                if let snacks1 = viewModel.beverages["snacks1"] {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .overlay(Image("snacks1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40))
                        VStack(alignment: .leading) {
                            Text("Snack 1:")
                                .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                .kerning(0.25)
                            striche(number: Int(snacks1[0]), price: snacks1[1])
                        }.padding(.leading, 5)
                        Spacer()
                    }
                }
                if let snacks2 = viewModel.beverages["snacks2"] {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .overlay(Image("snacks2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40))
                        VStack(alignment: .leading) {
                            Text("Snack 2:")
                                .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                .kerning(0.25)
                            striche(number: Int(snacks2[0]), price: snacks2[1])
                        }.padding(.leading, 5)
                        Spacer()
                    }
                }
                if let cocktails = viewModel.beverages["cocktail"] {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .overlay(Image("cocktail")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40))
                        VStack(alignment: .leading) {
                            Text("Cocktail:")
                                .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                .kerning(0.25)
                            striche(number: Int(cocktails[0]), price: cocktails[1])
                        }.padding(.leading, 5)
                        Spacer()
                    }
                }
                if let misc = viewModel.beverages["other"] {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .overlay(Image("cocktail_alcfree")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40))
                        VStack(alignment: .leading) {
                            Text("Special:")
                                .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                .kerning(0.25)
                            striche(number: Int(misc[0]), price: misc[1])
                        }.padding(.leading, 5)
                        Spacer()
                    }
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.horizontal)
            .frame(width: screen.width - 30, height: 80)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
    
    private func striche(number: Int, price: Double) -> AnyView {
        let blocks = Int(floor(Double(number / 5)))
        let singles = number % 5
        let view = AnyView(
            HStack {
                ForEach(0..<blocks, id: \.self) { _ in
                    Text("IIII")
                        .font(Font.system(size: 18, weight: .regular, design: .rounded))
                        .kerning(0.25)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .rotationEffect(Angle(degrees: -35))
                        )
                }
                Text("\(String(repeating: "I", count: singles))")
                    .font(Font.system(size: 18, weight: .regular, design: .rounded))
                    .kerning(0.25)
                Text("-  \(String(format: "%.2f", Double(number) * price))€")
                    .font(Font.system(size: 18, weight: .regular, design: .rounded))
                    .kerning(0.25)
            }
        )
        return view
    }
}

struct BookingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDetailView(viewModel: BookingDetailViewModel(booking: .mock), showing: .constant(true))
    }
}
