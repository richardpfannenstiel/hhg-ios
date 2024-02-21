//
//  SubtileAlertModifier.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 06.10.21.
//

import SwiftUI

struct SubtileAlertModifier: ViewModifier {
    
    let edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    let title: String
    let subtitle: String?
    let image: Image
    let showingClose: Bool
    let specialPadding: CGFloat?
    
    @Binding var isShowing: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack(alignment: .center) {
                SubtileAlert(title: title, subtitle: subtitle, image: image, showingClose: showingClose, isShowing: $isShowing)
                    .offset(y: isShowing ? (specialPadding != nil ? specialPadding! : edges!.top) : -200)
                Spacer()
            }
        }
    }
}

extension View {
    func subtileAlert(isShowing: Binding<Bool>, title: String, subtitle: String? = nil, image: Image, showingClose: Bool, specialPadding: CGFloat? = nil) -> some View {
        self.modifier(SubtileAlertModifier(title: title, subtitle: subtitle, image: image, showingClose: showingClose, specialPadding: specialPadding, isShowing: isShowing))
    }
}
