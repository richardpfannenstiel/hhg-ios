//
//  HaussprecherAccountView.swift
//  HHG
//
//  Created by Marc Fett on 25.03.22.
//

import SwiftUI

struct HaussprecherAccountView: View {
    
    @State var currentAccount: HaussprecherAccount = .HAUSSPRECHER
    
    private var cardBackground: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }
    }
    
    var body: some View {
        VStack {
            Text("Accounts".localized)
                .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                .kerning(0.25)
            Spacer()
            ForEach(HaussprecherAccount.allCases) { account in
                Button(action: { currentAccount = account }) {
                    HStack {
                        Text(account.rawValue)
                        Spacer()
                        if currentAccount == account {
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
            }
        }.padding(.vertical)
    }
}

struct HaussprecherAccountView_Previews: PreviewProvider {
    static var previews: some View {
        HaussprecherAccountView()
    }
}
