//
//  Lottie.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 03.04.22.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let animationView = AnimationView()
    var filename: String
    var loop: LottieLoopMode?
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        if let loop = loop {
            animationView.loopMode = loop
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) { }
}
