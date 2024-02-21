//
//  CustomAlert.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 16.07.21.
//

import SwiftUI

struct CustomAlert: View {
    
    @State var animationAmount: CGFloat = 0
    @State var attempts: Int = 0
    
    @Binding var isShowing: Bool
    
    let title: String
    let description: String?
    let boxes: [CustomAlertBox]
    
    
    var body: some View {
        alert
            .modifier(Shake(animatableData: CGFloat(attempts)))
            .scaleEffect(animationAmount)
            .animation(.interpolatingSpring(stiffness: 150, damping: 18))
            .onAppear {
                animationAmount = 1
            }
    }
    
    private var alert: some View {
        VStack {
            Text(title)
                .font(.system(size: 20))
                .bold()
                .padding(.vertical, 5)
            if let description = description {
                Text(description)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            ForEach(boxes) { box in
                Divider()
                Button(action: {
                    box.action()
                    animationAmount = 0
                    withAnimation {
                        isShowing.toggle()
                    }
                }, label: {
                    Text(box.text)
                        .font(.system(size: 20))
                        .padding(.horizontal)
                })
            }
            
        }.padding()
        .padding(.vertical, -5)
        .frame(width: UIScreen.main.bounds.width - 100)
        .background(Color.white)
        .cornerRadius(10)
        .animation(.default)
        .shadow(radius: 10)
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(isShowing: .constant(true), title: "Error", description: "Test Description", boxes: [CustomAlertBox(action: {}, text: "Okay")])
    }
}
