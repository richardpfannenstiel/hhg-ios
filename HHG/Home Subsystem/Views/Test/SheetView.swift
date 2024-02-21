//
//  SheetView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.08.21.
//

import Foundation
import SwiftUI
import UIKit

/*struct ABCView: View {
    
    @State var showingSheet = false
    
    var body: some View {
        Button(action: { showingSheet.toggle() }, label: {
            Text("Show")
        })
        .customSheet(showSheet: $showingSheet) {
            Text("Hallo2")
        }
    }
}

struct ABCView_Previews: PreviewProvider {
    static var previews: some View {
        ABCView()
    }
}

struct SheetHelper<SheetView: View>: UIViewControllerRepresentable {
    
    @Binding var showSheet: Bool
    
    var sheetView: SheetView
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            let sheetController = UIHostingController(rootView: sheetView)
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
            }
        }
    }
}*/
