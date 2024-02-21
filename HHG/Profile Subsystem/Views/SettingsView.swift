//
//  SettingsView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 06.03.22.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            residentView
            profileSettings
            experimentalView
            contributionsView
            Spacer()
        }.background(backgroundView)
        .slideView(isPresented: $viewModel.showingPasswordChange) {
            ChangePasswordView(viewModel: ChangePasswordViewModel(dismiss: viewModel.dismissPasswordChange))
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingEmail) {
            ChangeEmailView(viewModel: ChangeEmailViewModel(dismiss: viewModel.dismissEmail))
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingPhone) {
            ChangePhoneView(viewModel: ChangePhoneViewModel(dismiss: viewModel.dismissPhone))
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingResidentsOrder) {
            ChangeResidentOrderView(viewModel: ChangeResidentOrderViewModel(dismiss: viewModel.dismissResidentsOrder))
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingDevices) {
            DevicesListView(viewModel: DevicesListViewModel(dismiss: viewModel.dismissDevicesList))
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingContributions) {
            ContributionView(viewModel: ContributionViewModel(dismiss: viewModel.dismissContributions))
        } background: {
            Color.white
        }
        .slideView(isPresented: $viewModel.showingExperimental) {
            ExperimentalView(dismiss: viewModel.dismissExperimental)
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
        Button(action: viewModel.close) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var residentView: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text("\(resident.givenName) \(resident.familyName)")
                        .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                        .kerning(0.25)
                    Spacer()
                }.padding(.top, 50)
                Text("\(resident.roomNumber)")
                    .font(Font.system(size: 15, weight: .light, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.secondary)
            }.padding()
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal)
            profilePicture
                .offset(y: -60)
        }
    }
    
    private var profileSettings: some View {
        VStack {
            Button(action: viewModel.showPasswordChange) {
                HStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .overlay(Image("keys")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20))
                        .padding(.trailing, 5)
                    Text("Password".localized)
                    Spacer()
                    arrowView
                }.background(Color.white)
                    .padding(.vertical, 1)
            }.buttonStyle(PlainButtonStyle())
            Divider()
                .padding(.horizontal)
            Button(action: viewModel.showEmail) {
                HStack {
                    Image(systemName: "envelope.circle.fill")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 5)
                    Text("E-Mail".localized)
                    Spacer()
                    arrowView
                }.background(Color.white)
                .padding(.vertical, 1)
            }.buttonStyle(PlainButtonStyle())
            Divider()
                .padding(.horizontal)
            Button(action: viewModel.showPhone) {
                HStack {
                    Image(systemName: "phone.circle.fill")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 5)
                    Text("Phone".localized)
                    Spacer()
                    arrowView
                }.background(Color.white)
                    .padding(.vertical, 1)
            }.buttonStyle(PlainButtonStyle())
            Divider()
                .padding(.horizontal)
            Button(action: viewModel.showResidentsOrder) {
                HStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.HHG_DarkBlue)
                        .overlay(Image(systemName: "person.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white))
                        .padding(.trailing, 5)
                    Text("Resident".localized)
                    Spacer()
                    arrowView
                }.background(Color.white)
                    .padding(.vertical, 1)
            }.buttonStyle(PlainButtonStyle())
            Divider()
                .padding(.horizontal)
            Button(action: viewModel.showDevicesList) {
                HStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                        .overlay(Image(systemName: "laptopcomputer.and.iphone")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20))
                        .padding(.trailing, 5)
                    Text("Devices".localized)
                    Spacer()
                    arrowView
                }.background(Color.white)
            }.buttonStyle(PlainButtonStyle())
                .padding(.vertical, 1)
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var contributionsView: some View {
        VStack {
            Button(action: viewModel.showContributions) {
                HStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                        .overlay(Image(systemName: "heart.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 15, height: 15))
                        .padding(.trailing, 5)
                    Text("Contribution".localized)
                    Spacer()
                    arrowView
                }.background(Color.white)
            }.buttonStyle(PlainButtonStyle())
        }.padding(.horizontal)
        .padding(.vertical, 13)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var experimentalView: some View {
        VStack {
            Button(action: viewModel.showExperimental) {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.indigo)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 5)
                    Text("Experimental".localized)
                    Spacer()
                    arrowView
                }.background(Color.white)
            }.buttonStyle(PlainButtonStyle())
        }.padding(.horizontal)
        .padding(.vertical, 13)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var arrowView: some View {
        VStack {
            Spacer()
            Image(systemName: "chevron.right")
            Spacer()
        }.frame(height: 20)
    }
    
    private var profilePicture: some View {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.gray)
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(Text("\(String(resident.givenName.first!))\(String(resident.familyName.first!))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white))
    }
    
    private var resident: Resident {
        ResidentStore.shared.residents.first(where: { $0.id == viewModel.userID}) ?? Resident.mock
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(dismiss: {}))
    }
}
