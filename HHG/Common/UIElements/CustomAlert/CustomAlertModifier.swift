//
//  CustomAlertModifier.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.08.21.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    
    let title: String
    let description: String?
    let boxes: [CustomAlertBox]
    
    @Binding var isShowing: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isShowing {
                content
                    .disabled(true)
                    .blur(radius: 5.0)
                CustomAlert(isShowing: $isShowing, title: title,
                            description: description,
                            boxes: boxes)
            } else {
                content
            }
        }
    }
}

extension View {
    func customAlert(isShowing: Binding<Bool>, title: String, description: String?, boxes: [CustomAlertBox]) -> some View {
        self.modifier(CustomAlertModifier(title: title, description: description, boxes: boxes, isShowing: isShowing))
    }
}
