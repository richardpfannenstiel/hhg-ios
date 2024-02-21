//
//  DoneButtonTextField.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.03.22.
//

import SwiftUI

struct DoneButtonTextField: UIViewRepresentable {
    var placeholder: String
    var keyType: UIKeyboardType
    @Binding var text: String

    init(text: Binding<String>, keyType: UIKeyboardType, placeholder: String) {
        self.placeholder = placeholder
        self._text = text
        self.keyType = keyType
    }

         func makeUIView(context: Context) -> UITextField {
            let textfield = UITextField()
            textfield.keyboardType = keyType
            textfield.delegate = context.coordinator
            textfield.placeholder = placeholder
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
            let doneButton = UIBarButtonItem(title: "Fertig", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
            toolBar.items = [doneButton]
            toolBar.setItems([doneButton], animated: true)
            textfield.inputAccessoryView = toolBar
            return textfield
         }

         func updateUIView(_ uiView: UITextField, context: Context) {
            uiView.text = text
         }

         func makeCoordinator() -> Coordinator {
            Coordinator(self)
         }

         class Coordinator: NSObject, UITextFieldDelegate {
            var parent: DoneButtonTextField
        
         init(_ textField: DoneButtonTextField) {
            self.parent = textField
         }
        
         func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             if let currentValue = textField.text as NSString? {
                 let proposedValue = currentValue.replacingCharacters(in: range, with: string) as String
                 self.parent.text = proposedValue
             }
             return true
         }
       }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}
