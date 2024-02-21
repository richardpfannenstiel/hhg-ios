//
//  ShapeSlideIn.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 15.10.21.
//

import SwiftUI

extension View {
    
    func slideShape<Content:View, Background:View>(isPresented: Binding<Bool>, fullScreen: Binding<Bool>, content: @escaping () -> Content, background: @escaping () -> Background) -> some View {
        SlideShapeHelper(showing: isPresented, fullScreen: fullScreen, content: self, subcontent: content(), background: background())
    }
}

private struct SlideShapeHelper<Content:View, SubContent:View, Background:View>: View {
    let content: Content
    let subcontent: SubContent
    let background: Background
    
    @Binding var showing: Bool
    @Binding var fullScreen: Bool
    @State var animate = false
    
    init(showing: Binding<Bool>, fullScreen: Binding<Bool>, content: Content, subcontent: SubContent, background: Background) {
        self._showing = showing
        self._fullScreen = fullScreen
        self.content = content
        self.subcontent = subcontent
        self.background = background
    }
    
    var body: some View {
        content
            .overlay(
                ZStack {
                    if showing {
                        Color.black
                            .opacity(0.25)
                            .edgesIgnoringSafeArea([.top, .bottom])
                        ZStack {
                            background
                                .onTapGesture {
                                    withAnimation(Animation.easeInOut(duration: 1)) {
                                        fullScreen.toggle()
                                    }
                                    
                                }
                            subcontent
                                .onAppear {
                                    withAnimation(Animation.interactiveSpring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3).delay(0.2)) {
                                        animate.toggle()
                                    }
                                }
                                .onDisappear {
                                    animate.toggle()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }.clipShape(MenuShape(value: shapeValue))
                        .background(lineBackground)
                        .edgesIgnoringSafeArea([.top, .bottom])
                        .transition(.move(edge: .trailing))
                    }
                }
            )
    }
    
    private var shapeValue: CGFloat {
        if fullScreen {
            return -1
        } else {
            return animate ? 150 : 0
        }
    }
    
    private var lineBackground: some View {
        MenuShape(value: shapeValue)
            .stroke(
                LinearGradient(gradient: Gradient(colors: [
                    Color.HHG_LightBlue,
                    Color.HHG_LightBlue.opacity(0.7),
                    Color.HHG_LightBlue.opacity(0.5),
                    Color.clear
                ]), startPoint: .top, endPoint: .bottom),
                lineWidth: animate ? 7 : 0
            )
    }
}

struct MenuShape: Shape {
    
    var value: CGFloat
    
    var animatableData: CGFloat {
        get {
            value
        }
        set {
            value = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
//            let width = rect.width - 100
//            let height = rect.height
//
//            path.move(to: CGPoint(x: width, y: height))
//            path.addLine(to: CGPoint(x: 0, y: height))
//            path.addLine(to: CGPoint(x: 0, y: 0))
//            path.addLine(to: CGPoint(x: width, y: 0))
//
//            path.move(to: CGPoint(x: width, y: 0))
//
//            path.addCurve(to: CGPoint(x: width, y: height + 100), control1: CGPoint(x: width + value, y: height / 3), control2: CGPoint(x: width - value, y: height / 2))
            if value < 0 {
                let width = rect.width
                let height = rect.height
                
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 0))
                
//                path.move(to: CGPoint(x: 0, y: 0))
//                
//                path.addCurve(to: CGPoint(x: 100, y: height + 100), control1: CGPoint(x: 100 - value, y: height / 3), control2: CGPoint(x: 50 + value, y: height / 2))
            } else {
                let width = rect.width
                let height = rect.height
                
                path.move(to: CGPoint(x: 100, y: height))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: 100, y: 0))
                
                path.move(to: CGPoint(x: 100, y: 0))
                
                path.addCurve(to: CGPoint(x: 100, y: height + 100), control1: CGPoint(x: 100 - value, y: height / 3), control2: CGPoint(x: 50 + value, y: height / 2))
            }
            
            
        }
    }
}

