//
//  SwipePopExtension.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 10.09.21.
//

import SwiftUI

extension View {
    
    func scaleView<Content:View, Background:View>(frame: CGRect, isPresented: Binding<Bool>, content: @escaping () -> Content, background: @escaping () -> Background) -> some View {
        SwipeScaleHelper(frame: frame, showing: isPresented, content: self, subcontent: content(), background: background())
    }
}

private struct SwipeScaleHelper<Content:View, SubContent:View, Background:View>: View {
    let content: Content
    let subcontent: SubContent
    let background: Background
    
    let frame: CGRect
    
    @Binding var showing: Bool
    @GestureState var gestureOffsetX: CGFloat = 0
    @GestureState var gestureOffsetY: CGFloat = 0
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0
    
    @State var vibrated: Bool = false
    
    let maxtranslationX = UIScreen.main.bounds.width / 3.5
    let maxtranslationY = UIScreen.main.bounds.height / 3.5
    
    init(frame: CGRect, showing: Binding<Bool>, content: Content, subcontent: SubContent, background: Background) {
        self.frame = frame
        self._showing = showing
        self.content = content
        self.subcontent = subcontent
        self.background = background
    }
    
    private var contentOpacity: Double {
        if height != UIScreen.main.bounds.height {
            return 0
        }
        return Double(subContentScale * 1.5 - 0.9)
    }
    
    private var subContentScale: CGFloat {
        let yscale = 1 - (abs(offsetY / UIScreen.main.bounds.height) / 4)
        let xscale = 1 - (abs(offsetX / UIScreen.main.bounds.width) / 4)
        return max(min(xscale, yscale), 0.9)
    }
    
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    var body: some View {
        content
            .overlay(
                ZStack {
                    if showing {
                        Color.black
                            .opacity(contentOpacity)
                            .edgesIgnoringSafeArea([.top, .bottom])
                        subcontent
                            .frame(width: width, height: height)
                            .background(background)
                            .cornerRadius(15)
                            .scaleEffect(subContentScale)
                            .offset(x: offsetX, y: offsetY)
                            .edgesIgnoringSafeArea(.top)
                            .gesture(DragGesture()
                                        .updating($gestureOffsetX, body: { value, out, _ in
                                            out = value.translation.width
                                            let translationX = abs(value.translation.width)
                                
                                            if translationX > maxtranslationX {
                                                if !vibrated {
                                                    vibrate()
                                                }
                                            }
                                        })
                                        .updating($gestureOffsetY, body: { value, out, _ in
                                            out = value.translation.height
                                            let translationY = abs(value.translation.height)
                                            
                                            if translationY > maxtranslationY {
                                                if !vibrated {
                                                    vibrate()
                                                }
                                            }
                                        })
                                        .onEnded({ value in
                                            withAnimation(Animation.easeOut(duration: 0.4)) {
                                                let translationX = abs(value.translation.width)
                                                let translationY = abs(value.translation.height)
                                                
                                                if translationX > maxtranslationX || translationY > maxtranslationY {
                                                    /*width = minWidth
                                                    height = minHeight
                                                    withAnimation {
                                                        showing = false
                                                        width = UIScreen.main.bounds.width
                                                        height = UIScreen.main.bounds.height
                                                    }*/
                                                    dismiss()
                                                    
                                                }
                                                
                                                offsetX = 0
                                                offsetY = 0
                                                vibrated.toggle()
                                            }
                                        })
                            )
                            /*.transition(
                                AnyTransition.scale(scale: 0.12)
                                    .combined(with: AnyTransition.offset(x: frame.origin.x - width / 2, y: frame.origin.y - height / 2))
                                    .combined(with: AnyTransition.opacity)
                            )*/
                            .transition(AnyTransition.move(edge: .bottom))
                    }
                }.onChange(of: gestureOffsetX, perform: { newValue in
                    offsetX = gestureOffsetX / 2
                }).onChange(of: gestureOffsetY, perform: { newValue in
                    offsetY = gestureOffsetY / 2
                })
            )
    }
    
    private func dismiss() {
        withAnimation(Animation.easeIn) {
            showing = false
        }
    }
    
    private func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        vibrated.toggle()
    }
}
