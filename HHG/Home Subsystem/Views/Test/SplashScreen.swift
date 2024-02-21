//
//  SplashScreen.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 10.08.21.
//

import SwiftUI

struct SplashScreen<Content: View, Logo: View>: View {
    
    let content: Content
    let logo: Logo
    
    var logoSize: CGSize
    
    @State var logoAnimation = false
    @Namespace var animation
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel, logoSize: CGSize, @ViewBuilder content: @escaping () -> Content, @ViewBuilder logo: @escaping () -> Logo) {
        self.content = content()
        self.logo = logo()
        self.logoSize = logoSize
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            /*if viewModel.showingHeader {
                ZStack {
                    Color("Blue")
                        .edgesIgnoringSafeArea(.all)
                    if !logoAnimation {
                        logo
                            .matchedGeometryEffect(id: "LOGO", in: animation)
                            .frame(width: 150, height: 150)
                    }
                    if !logoAnimation {
                        logo
                            .matchedGeometryEffect(id: "LOGO", in: animation)
                            .frame(width: 150, height: 150)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.3)
                            .offset(y: 130)
                    }
                    
                    HStack {
                        Spacer()
                        if logoAnimation {
                            logo
                                .matchedGeometryEffect(id: "LOGO", in: animation)
                                .frame(width: 40, height: 40)
                                .padding(.trailing)
                                .offset(y: -5)
                        }
                    }
                    
                }.frame(height: logoAnimation ? 60 : nil)
            }
            
            content
                .frame(height: logoAnimation ? nil : 0)
             */
            
        }.frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(Animation.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
                    logoAnimation.toggle()
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
