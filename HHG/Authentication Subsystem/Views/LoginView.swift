//
//  LoginView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.08.21.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @Namespace var animation
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                circles
                    .offset(y: viewModel.circlesOffset)
                logo
                    .matchedGeometryEffect(id: "LOGO", in: animation)
                    .frame(width: 120, height: 120)
                    
                Spacer()
                usernameTextField
                passwordTextField
                forgotPasswordButton
                Spacer()
                signInButton
                Spacer()
            }.padding(.horizontal)
            .opacity(1 - viewModel.opacity)
            
            if !viewModel.logoAnimation {
                logo
                    .matchedGeometryEffect(id: "LOGO", in: animation)
                    .frame(width: 150, height: 150)
                if viewModel.loginAnimation {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.3)
                        .offset(y: 130)
                }
            }
        }.customAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, description: viewModel.alertDescription, boxes: viewModel.alertBoxes)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.animate(login: false, opacity: 0)
            }
        }
    }
    
    private var backgroundColor: some View {
        Color.HHG_Blue
            .opacity(viewModel.opacity)
            .edgesIgnoringSafeArea(.all)
    }
    
    private var circles: some View {
        GeometryReader { proxy -> AnyView in
            let height = proxy.frame(in: .global).height
            
            return AnyView(
                ZStack {
                    Circle()
                        .fill(Color.HHG_Blue)
                        .offset(x: getRect().width / 2, y: -height / 1.3)
                        .frame(height: viewModel.circleAnimation ? 300 : 20)
                    Circle()
                        .fill(Color.HHG_LightBlue)
                        .offset(x: -getRect().width / 2, y: -height / 1.5)
                        .frame(height: viewModel.circleAnimation ? 300 : 20)
                    Circle()
                        .fill(Color.HHG_DarkBlue)
                        .offset(y: -height / 1.3)
                        .rotationEffect(.init(degrees: -5))
                        .frame(height: viewModel.circleAnimation ? 300 : 20)
                        .matchedGeometryEffect(id: "CIRCLE", in: animation)
                }
            )
        }.frame(maxHeight: getRect().width / 2)
    }
    
    private var logo: some View {
        Image("hhg_icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private var usernameTextField: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(.bottom, 10)
            VStack {
                TextField("Username".localized, text: $viewModel.username, onCommit:  {
                    viewModel.setCircles(offset: -50)
                }).onTapGesture {
                    viewModel.setCircles(offset: -150)
                }.disableAutocorrection(true)
                .autocapitalization(.none)
                Divider()
            }.padding()
        }
    }
    
    private var passwordTextField: some View {
        HStack {
            Image(systemName: "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(.bottom, 10)
            VStack {
                if viewModel.showingPasswordClear {
                    TextField("Password".localized, text: $viewModel.password, onCommit:  {
                        viewModel.setCircles(offset: -50)
                    }).onTapGesture {
                        viewModel.setCircles(offset: -150)
                    }.disableAutocorrection(true)
                    .autocapitalization(.none)
                } else {
                    SecureField("Password".localized, text: $viewModel.password) {
                        viewModel.setCircles(offset: -50)
                    }.onTapGesture {
                        viewModel.setCircles(offset: -150)
                    }
                }
                Divider()
            }.padding()
            Button(action: { viewModel.showingPasswordClear.toggle() }, label: {
                Image(systemName: viewModel.showingPasswordClear ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(viewModel.showingPasswordClear ? .green : .secondary)
            }).padding(.bottom)
        }
    }
    
    private var forgotPasswordButton: some View {
        Button(action: viewModel.forgotPassword) {
            Text("Forgot password?".localized)
                .foregroundColor(.HHG_Blue)
        }.padding(.bottom, 40)
    }
    
    private var signInButton: some View {
        Button(action: viewModel.login) {
            Text("Login".localized)
                .foregroundColor(.white)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(width: (UIScreen.main.bounds.width - 45), height: 60)
                .background(viewModel.credentialsEmpty ? Color.secondary : Color.HHG_Blue)
                .cornerRadius(15)
        }.disabled(viewModel.credentialsEmpty)
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
