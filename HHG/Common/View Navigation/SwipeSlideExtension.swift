//
//  SwipeSlideExtension.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 25.02.22.
//

import SwiftUI

extension View {
    
    func slideView<Content:View, Background:View>(isPresented: Binding<Bool>, content: @escaping () -> Content, background: @escaping () -> Background) -> some View {
        SlideHelper(showing: isPresented, content: self, subcontent: content(), background: background())
    }
}

private struct SlideHelper<Content:View, SubContent:View, Background:View>: View {
    let content: Content
    let subcontent: SubContent
    let background: Background
    
    @Binding var showing: Bool
    @GestureState var gestureOffsetX: CGFloat = 0
    @State var offsetX: CGFloat = 0
    
    @State var vibrated: Bool = false
    
    let maxtranslationX = UIScreen.main.bounds.width / 1.8
    
    init(showing: Binding<Bool>, content: Content, subcontent: SubContent, background: Background) {
        self._showing = showing
        self.content = content
        self.subcontent = subcontent
        self.background = background
    }
    
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    var body: some View {
        content
            .overlay(
                ZStack {
                    if showing {
//                        Color.black
//                            .opacity(contentOpacity)
//                            .edgesIgnoringSafeArea([.top, .bottom])
                        subcontent
                            .frame(width: width)
                            .frame(maxHeight: height)
                            .background(background)
                            .cornerRadius(15)
                            .offset(x: offsetX)
                            .edgesIgnoringSafeArea([.top, .bottom])
                            .gesture(DragGesture()
                                        .updating($gestureOffsetX, body: { value, out, _ in
                                            if value.translation.width < 0 {
                                                return
                                            }
                                
                                            out = value.translation.width
                                            
                                            let translationX = abs(value.translation.width)
                                
                                            if translationX > maxtranslationX {
                                                if !vibrated {
                                                    vibrate()
                                                }
                                            }
                                        })
                                        .onEnded({ value in
                                            withAnimation(Animation.easeOut(duration: 0.4)) {
                                                if value.translation.width < 0 {
                                                    return
                                                }
                                                
                                                let translationX = abs(value.translation.width)
                                                
                                                if translationX > maxtranslationX {
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
                                                vibrated.toggle()
                                            }
                                        })
                            )
                            /*.transition(
                                AnyTransition.scale(scale: 0.12)
                                    .combined(with: AnyTransition.offset(x: frame.origin.x - width / 2, y: frame.origin.y - height / 2))
                                    .combined(with: AnyTransition.opacity)
                            )*/
                            .transition(AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                    }
                }.onChange(of: gestureOffsetX, perform: { newValue in
                    if gestureOffsetX > 0 {
                        offsetX = gestureOffsetX
                    }
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
        DispatchQueue.main.async {
            vibrated.toggle()
        }
    }
}
