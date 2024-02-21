//
//  NumberTextField.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.03.22.
//

import SwiftUI

struct NumberTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var becameFirstResponder = false
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let adaptedText = textField.text {
                if adaptedText.count < 7 && (Int(adaptedText) != nil || adaptedText.isEmpty) {
                    text = adaptedText
                }
            }
            textField.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textfield = UITextField()
        textfield.delegate = context.coordinator
        textfield.textColor = UIColor.clear
        textfield.tintColor = UIColor.clear
        textfield.keyboardType = .numberPad
        return textfield
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}
