//
//  SubtileAlert.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 06.10.21.
//

import SwiftUI

struct SubtileAlert: View {
    
    let title: String
    let subtitle: String?
    let image: Image
    let showingClose: Bool
    
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: 23, height: 23)
            Spacer()
            text
            Spacer()
            close
        }.padding(.horizontal)
        
        .frame(width: UIScreen.main.bounds.width / 1.8, height: 50)
        .background(VisualEffectView(effect: UIBlurEffect.init(style: .systemChromeMaterialLight)))
        .cornerRadius(25)
    }
    
    private var text: some View {
        VStack {
            Text(title)
                .font(Font.system(size: 15, weight: .semibold, design: .rounded))
                .kerning(0.25)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Font.system(size: 15, weight: .regular, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var close: some View {
        Button(action: { withAnimation { isShowing.toggle() } }) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.HHG_Blue)
                .frame(width: 25, height: 25)
        }.opacity(showingClose ? 1 : 0)
    }
}

struct SubtileAlert_Previews: PreviewProvider {
    static var previews: some View {
        SubtileAlert(title: "Schlafen", subtitle: "Ein", image: Image(systemName: "bed.double.fill"), showingClose: true, isShowing: .constant(true))
    }
}
