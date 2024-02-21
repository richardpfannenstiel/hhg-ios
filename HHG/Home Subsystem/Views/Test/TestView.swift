//
//  TestView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.08.21.
//

import SwiftUI

struct TestView<BackgroundView: View, SheetView: View>: View {
    
    var backgroundView: BackgroundView
    var sheetView: SheetView
    @Binding var showSheet: Bool
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                backgroundView
                //let frame = proxy.frame(in: .global)
                //Color("Blue")
                    //.frame(width: frame.width, height: frame.height)
            }.blur(radius: getBlurRadius())
            .ignoresSafeArea()
            
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                return AnyView(
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                        VStack {
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 60, height: 4)
                        }.frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top)
                    }.offset(y: height - 100)
                    .offset(y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.height
                        onChange()
                    }).onEnded({ value in
                        let maxHeight = height - 100
                        withAnimation {
                            if -offset > 100 && -offset < maxHeight / 2 {
                                offset = -(maxHeight / 3)
                            } else if -offset > maxHeight / 2 {
                                offset = -maxHeight
                            } else {
                                offset = 0
                            }
                        }
                        
                        lastOffset = offset
                    }))
                )
            }.ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func getBlurRadius() -> CGFloat {
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        return progress * 30
    }
}

extension View {
    func customSheet<SheetView: View>(showSheet: Binding<Bool>, sheetView: SheetView) -> some View {
        return TestView(backgroundView: self, sheetView: sheetView, showSheet: showSheet)
    }
}
