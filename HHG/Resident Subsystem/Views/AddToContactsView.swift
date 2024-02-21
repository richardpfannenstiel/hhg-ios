//
//  AddToContactsView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 10.07.21.
//

import SwiftUI
import MapKit

struct AddToContactsView: View {
    
    @StateObject var viewModel: AddToContactsViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    closeButton
                    Spacer()
                    addButtonView
                }
                nameView
                contactInformationView
                locationView
                Spacer()
            }.onTapGesture {
                UIApplication.shared.dismissKeyboard()
            }
        }.background(
            backgroundView
        ).customAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, description: viewModel.alertDescription, boxes: viewModel.alertBoxes)
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
    
    private var addButtonView: some View {
        Button(action: viewModel.addToContacts, label: {
            Text("Save".localized)
        }).padding()
    }
    
    private var nameView: some View {
        VStack {
            TextField("First name".localized, text: $viewModel.givenName)
                .padding(.horizontal)
            Divider()
                .padding(.horizontal)
            TextField("Last name".localized, text: $viewModel.familyName)
                .padding(.horizontal)
        }.padding(.vertical)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var contactInformationView: some View {
        VStack {
            TextField("Phone".localized, text: $viewModel.telephoneNumber)
                .keyboardType(.phonePad)
                .padding(.horizontal)
            Divider()
                .padding(.horizontal)
            TextField("E-Mail", text: $viewModel.mail)
                .keyboardType(.emailAddress)
                .padding(.horizontal)
        }.padding(.vertical)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var locationView: some View {
        VStack {
            Toggle(isOn: $viewModel.includeLocation, label: {
                Text("Save address".localized)
            }).padding(.horizontal)
            if viewModel.includeLocation {
                Divider()
                    .padding(.horizontal)
                MapView(coordinate: CLLocationCoordinate2D(latitude: 48.257023, longitude: 11.655169))
                    .frame(height: 150)
                    .cornerRadius(8)
                    .padding()
                HStack(alignment: .center) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.HHG_Blue)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 5)
                    Text("Enzianstraße \(viewModel.house.number)\n85748 Garching bei München")
                        .font(Font.system(size: 17, weight: .light, design: .rounded))
                        .kerning(0.25)
                    Spacer()
                }.padding(.horizontal)
            }
        }.padding(.vertical)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct AddToContactsView_Previews: PreviewProvider {
    static var previews: some View {
        AddToContactsView(viewModel: AddToContactsViewModel(resident: Resident.mock, dismiss: {}))
    }
}
