//
//  SettingsView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 24.02.22.
//

import SwiftUI

struct MenuView: View {
    
    @StateObject var viewModel: MenuViewModel
    
    var body: some View {
        VStack {
            Spacer()
            profilePicture
            Text("\(resident.givenName) \(resident.familyName) - \(resident.roomNumber)")
                .font(Font.system(size: 15, weight: .light, design: .rounded))
                .kerning(0.25)
            Spacer()
            VStack {
                MenuRowView(title: "Settings".localized, description: "Edit account".localized, icon: "gear", action: viewModel.showSettings)
                MenuRowView(title: "Wiki", description: "F.A.Q Website".localized, icon: "questionmark.circle", action: viewModel.showWiki)
                MenuRowView(title: "Fileserver".localized, description: "Dormitory files".localized, icon: "folder.circle", action: viewModel.showFileserver)
                MenuRowView(title: "Sign out".localized, description: "Logout of your account".localized, icon: "person.crop.circle", action: viewModel.signOut)
            }
            Spacer()
        }.sheet(isPresented: $viewModel.showingSettings) {
            SettingsView(viewModel: SettingsViewModel(dismiss: viewModel.closeSettings))
        }
    }
    
    private var profilePicture: some View {
        Circle()
            .frame(width: 70, height: 70)
            .foregroundColor(Color.gray)
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(Text("\(String(resident.givenName.first!))\(String(resident.familyName.first!))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white))
    }
    
    private var resident: Resident {
        ResidentStore.shared.residents.first(where: { $0.id == viewModel.userID}) ?? Resident.mock
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(viewModel: MenuViewModel(dismiss: {}))
    }
}
