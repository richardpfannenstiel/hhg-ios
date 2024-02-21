//
//  DepositView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.02.22.
//

import SwiftUI

struct DepositView: View {
    
    @StateObject var viewModel = DepositViewModel()
    @Binding var showing: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    closeButton
                    Spacer()
                }.offset(y: 50)
                VStack {
                    Text("Top up account".localized)
                        .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                        .kerning(0.25)
                    Text("You can add cash to your account with the following people.".localized)
                        .font(Font.system(size: 15, weight: .light, design: .rounded))
                        .kerning(0.25)
                        .multilineTextAlignment(.center)
                }.offset(y: 50)
                topUpPartnersView
                    .padding(.top, 80)
                    .padding(.bottom, 30)
            }.padding(.horizontal)
        }.background(
            backgroundView
        )
        .slideView(isPresented: $viewModel.showingResident) {
            ResidentDetailView(viewModel: ResidentDetailViewModel(resident: viewModel.selectedResident!), showing: $viewModel.showingResident)
        } background: {
            Color.white
        }
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
    
    private var topUpPartnersView: some View {
        ScrollView {
            VStack(spacing: 20) {
                houseSpeakerView
                ForEach(viewModel.depositPartners.filter( { $0.givenName == "Angelika" && $0.familyName == "Beckert" })) { partner in
                    Button(action: { viewModel.select(partner) }) {
                        CashPartnerView(partner: partner)
                            .background(Color.white)
                            .frame(width: screen.width - 50)
                    }.buttonStyle(PlainButtonStyle())
                }
                houseRepresentativeView
                ForEach(viewModel.depositPartners.filter( { $0.userGroups.contains("haussprecher") })) { partner in
                    Button(action: { viewModel.select(partner) }) {
                        CashPartnerView(partner: partner)
                            .background(Color.white)
                            .frame(width: screen.width - 50)
                    }.buttonStyle(PlainButtonStyle())
                }
                barTeamView
                ForEach(viewModel.depositPartners.filter( { $0.userGroups.contains("barteam") })) { partner in
                    Button(action: { viewModel.select(partner) }) {
                        CashPartnerView(partner: partner)
                            .background(Color.white)
                            .frame(width: screen.width - 50)
                    }.buttonStyle(PlainButtonStyle())
                }
            }.frame(width: screen.width - 50)
            .padding(.vertical)
            
        }
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var houseRepresentativeView: some View {
        VStack {
            HStack {
                Text("House Speaker".localized)
                    .font(Font.system(size: 13, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.secondary)
                Spacer()
            }
            Divider()
        }.padding(.horizontal)
    }
    
    private var barTeamView: some View {
        VStack {
            HStack {
                Text("Barteam")
                    .font(Font.system(size: 13, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.secondary)
                Spacer()
            }
            Divider()
        }.padding(.horizontal)
    }
    
    private var houseSpeakerView: some View {
        VStack {
            HStack {
                Text("House Management".localized)
                    .font(Font.system(size: 13, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.secondary)
                Spacer()
            }
            Divider()
        }.padding(.horizontal)
    }
}

struct DepositView_Previews: PreviewProvider {
    static var previews: some View {
        DepositView(showing: .constant(true))
    }
}
