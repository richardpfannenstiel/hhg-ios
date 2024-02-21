//
//  BottomSheetView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 08.10.21.
//

import SwiftUI

private struct BottomSheetView<Content:View, SubContent:View, Background:View>: View {
    let content: Content
    let subcontent: SubContent
    let background: Background
    let height: CGFloat
    let dismiss: () -> ()
    
    @Binding var showing: Bool
    @GestureState var gestureOffsetY: CGFloat = 0
    @State var offsetY: CGFloat = 0
    @State var viewState = CGSize.zero
    
    init(showing: Binding<Bool>, dismiss: @escaping () -> (), height: CGFloat, content: Content, subcontent: SubContent, background: Background) {
        self._showing = showing
        self.dismiss = dismiss
        self.height = height
        self.content = content
        self.subcontent = subcontent
        self.background = background
    }
    
    var body: some View {
        ZStack {
            content
                .blur(radius: showing ? 3 : 0)
//            Color.black
//                .opacity(showing ? 0.2 : 0)
//                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                Spacer()
                ZStack {
                    subcontent
                        .frame(width: screen.width - 100)
                    VStack {
                        HStack {
                            Spacer()
                            closeButton
                                .padding()
                        }
                        Spacer()
                    }
                }
                .frame(height: height)
                .frame(width: screen.width - 70)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .padding(.horizontal, 30)
            }.background(Color.black.opacity(0.001))
            .offset(y: showing ? -30 : screen.height)
            .offset(y: viewState.height)
            .gesture(
                DragGesture().onChanged { value in
                    viewState = value.translation
                }
                .onEnded { value in
                    if viewState.height > 50 {
                        withAnimation(.spring()) { dismiss() }
                    }
                    withAnimation {
                        viewState = .zero
                    }
                    
                }
            )
            
        }
    }
    
    private var closeButton: some View {
        Button(action: withAnimation { dismiss }) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
        }
    }
}


extension View {
    
    func bottomSheet<Content:View, Background:View>(isPresented: Binding<Bool>, dismiss: @escaping () -> (), height: CGFloat, content: @escaping () -> Content, background: @escaping () -> Background) -> some View {
        BottomSheetView(showing: isPresented, dismiss: dismiss, height: height, content: self, subcontent: content(), background: background())
    }
}

