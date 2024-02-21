//
//  ResidentDetailView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import SwiftUI

struct ResidentDetailView: View {
    
    @StateObject var viewModel: ResidentDetailViewModel
    @Binding var showing: Bool
    
    var body: some View {
        VStack {
            VStack {
                Image("maps_view")
                    .resizable()
                    .frame(height: screen.height / 3)
                    .offset(y: 20)
                    .cornerRadius(40)
                    .overlay(
                        HStack {
                            closeButton
                            Spacer()
                        }.padding(.horizontal)
                    )
                profilePicture
                    .scaleEffect(viewModel.profileScale)
                    .offset(y: -100)
                    .padding(.bottom, -100)
                nameView
                hitButtonsView
                newInformationList
                    
                Spacer()
            }.offset(y: -70)
            .padding(.bottom, -70)
        }.background(Color.secondary.opacity(0.15))
        .font(.body)
        .edgesIgnoringSafeArea(.all)
        .customAlert(isShowing: $viewModel.showingNoContactsAccessAlert, title: viewModel.alertTitle, description: viewModel.alertDescription, boxes: viewModel.alertBoxes)
        .onAppear {
            viewModel.scaleProfile()
            viewModel.vibrate()
        }
    }
    
    private var closeButton: some View {
        Button(action: { withAnimation { showing = false }}) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }
    }
    
    private var profilePicture: some View {
        Circle()
            .frame(width: 150, height: 150)
            .foregroundColor(Color.gray)
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(Text("\(String(viewModel.resident.givenName.first!))\(String(viewModel.resident.familyName.first!))")
                        .font(Font.system(size: 40, weight: .bold, design: .rounded))
                        .kerning(0.25)
                        .foregroundColor(.white))
    }
    
    private var nameView: some View {
        VStack {
            HStack {
                Text("\(viewModel.resident.givenName) \(viewModel.resident.familyName)")
                    .font(Font.system(size: 30, weight: .semibold, design: .rounded))
                    .kerning(0.25)
            }
            Text("\(viewModel.resident.roomNumber)")
                .font(Font.system(size: 17, weight: .light, design: .rounded))
                .kerning(0.25)
                .foregroundColor(.secondary)
        }
    }
    
    private var hitButtonsView: some View {
        HStack {
            Button(action: viewModel.message, label: {
                VStack {
                    Image(systemName: "message.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Message".localized)
                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                        .kerning(0.25)
                }.frame(width: UIScreen.main.bounds.width / 4 - 10, height: 60, alignment: .center)
                    .foregroundColor(viewModel.equalsUser() || viewModel.resident.telephoneNumber == nil ? Color.secondary : .HHG_Blue)
                .background(Color.white)
                .cornerRadius(10)
            }).buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: viewModel.call, label: {
                VStack {
                    Image(systemName: "phone.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Call".localized)
                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                        .kerning(0.25)
                }.frame(width: UIScreen.main.bounds.width / 4 - 10, height: 60, alignment: .center)
                    .foregroundColor(viewModel.equalsUser() || viewModel.resident.telephoneNumber == nil ? Color.secondary : .HHG_Blue)
                .background(Color.white)
                .cornerRadius(10)
            }).buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: viewModel.sendMoney, label: {
                VStack {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Send money".localized)
                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                        .kerning(0.25)
                }.frame(width: UIScreen.main.bounds.width / 4 - 10, height: 60, alignment: .center)
                    .foregroundColor(viewModel.equalsUser() ? Color.secondary : .HHG_Blue)
                .background(Color.white)
                .cornerRadius(10)
            }).buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $viewModel.showingMoneyTransfer) {
                TransactionView(viewModel: TransactionViewModel(receiver: viewModel.resident, dismiss: viewModel.closeSendMoney))
            }
            Spacer()
            Button(action: viewModel.addToContacts, label: {
                VStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .frame(width: 25, height: 20)
                    Text("Add".localized)
                        .font(Font.system(size: 13, weight: .light, design: .rounded))
                        .kerning(0.25)
                }.frame(width: UIScreen.main.bounds.width / 4 - 10, height: 60, alignment: .center)
                    .foregroundColor(viewModel.equalsUser() ? Color.secondary : .HHG_Blue)
                .background(Color.white)
                .cornerRadius(10)
            }).buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $viewModel.showingAddToContacts) {
                AddToContactsView(viewModel: AddToContactsViewModel(resident: viewModel.resident, dismiss: viewModel.dismissAddToContacts))
                    .preferredColorScheme(.light)
            }
        }.padding(.horizontal, 8)
        .padding(.vertical)
    }
    
    private var newInformationList: some View {
        SwiftUI.ScrollView {
            VStack {
                VStack {
                    HStack {
                        Text("Apartment".localized)
                            .font(Font.system(size: 13, weight: .light, design: .rounded))
                            .kerning(0.25)
                        Spacer()
                    }
                    HStack {
                        Text("\(viewModel.resident.roomNumber)")
                            .font(Font.system(size: 16, weight: .regular, design: .rounded))
                            .kerning(0.25)
                        Spacer()
                    }
                }.padding(10)
                .background(Color.white)
                .cornerRadius(10)
                if let mail = viewModel.resident.mail {
                    Button(action: viewModel.email) {
                        VStack {
                            HStack {
                                Text("E-Mail")
                                    .font(Font.system(size: 13, weight: .light, design: .rounded))
                                    .kerning(0.25)
                                Spacer()
                            }
                            HStack {
                                Text("\(mail)")
                                    .font(Font.system(size: 16, weight: .regular, design: .rounded))
                                    .kerning(0.25)
                                Spacer()
                            }
                        }.padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                    }.buttonStyle(PlainButtonStyle())
                }
                if let phone = viewModel.resident.telephoneNumber {
                    VStack {
                        HStack {
                            Text("Mobile".localized)
                                .font(Font.system(size: 13, weight: .light, design: .rounded))
                                .kerning(0.25)
                            Spacer()
                        }
                        HStack {
                            Text("\(phone)")
                                .font(Font.system(size: 16, weight: .regular, design: .rounded))
                                .kerning(0.25)
                            Spacer()
                        }
                    }.padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }.padding(.horizontal, 10)
    }
}

struct ResidentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ResidentDetailView(viewModel: ResidentDetailViewModel(resident: Resident.mock), showing: .constant(true))
    }
}
