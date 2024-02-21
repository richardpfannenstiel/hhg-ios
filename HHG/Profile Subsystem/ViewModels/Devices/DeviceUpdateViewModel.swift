//
//  DeviceRegisterViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.03.22.
//

import SwiftUI
import Combine

final class DeviceUpdateViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var description = ""
    
    @Published var sendingRequest = false
    @Published var addDeviceSuccessfully = false
    @Published var sendingDeleteRequest = false
    @Published var deleteDeviceSuccessfully = false
    
    @Published var showingAlert = false
    @Published var showingSubtileAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    @Published var alertBoxes: [CustomAlertBox] = []
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    let dismiss: () -> ()
    let reload: () -> ()
    
    let device: Device
    
    // MARK: Computed Properties
    
    var validParameters: Bool {
        !description.isEmpty
    }
    
    var computedMac: String {
        if device.mac.count != 12 {
            return ""
        }
        return device.mac.reduce("", { "\($0)\([2, 5, 8, 11, 14].contains($0.count) ? ":" : "")\($1)" })
    }
    
    // MARK: Initializers
    
    init(dismiss: @escaping () -> (), reload: @escaping () -> (), device: Device) {
        self.dismiss = dismiss
        self.reload = reload
        self.device = device
        description = device.description
    }
    
    // MARK: Methods
    
    private func showEmptyFields() {
        alertTitle = "Fehler".localized
        alertDescription = "Please fill in all text fields.".localized
        alertBoxes = [CustomAlertBox(action: {}, text: "Okay")]
        showAlert()
    }
    
    private func showAlert() {
        withAnimation {
            showingAlert.toggle()
        }
    }
    
    func delete() {
        dismissKeyboard()
        sendDelete()
    }
    
    func sendDelete() {
        if sendingDeleteRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingDeleteRequest = true
        }
        
        let url = ServerURL.deleteDevice.constructedURL
        let body = ["authtoken" : authtoken, "deviceid" : "\(device.id)"]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[String : String]> in
                guard let _ = err as? URLError else {
                    return Just(["success" : ""])
                }
                return Just(["error" : ""])
            })
            .map({ $0["success"] != nil })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [self] success in
                if success {
                    deleteSucceeded()
                } else {
                    deleteFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    func update() {
        if !validParameters {
            showEmptyFields()
            return
        }
        
        dismissKeyboard()
        send()
    }
    
    func send() {
        if sendingRequest {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            sendingRequest = true
        }
        
        let url = ServerURL.updateDevice.constructedURL
        let body = ["authtoken" : authtoken, "deviceid" : "\(device.id)", "description" : "\(description)"]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[String : String]> in
                guard let _ = err as? URLError else {
                    return Just(["success" : ""])
                }
                return Just(["error" : ""])
            })
            .map({ $0["success"] != nil })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [self] success in
                if success {
                    changeSucceeded()
                } else {
                    changeFailed()
                }
            })
            .store(in: &cancellables)
    }
    
    private func changeSucceeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            withAnimation {
                addDeviceSuccessfully = true
            }
            reload()
            showAddedAlert()
            vibrate(type: .success)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            dismiss()
        }
    }
    
    private func changeFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            vibrate(type: .error)
            showErrorAlert()
            withAnimation {
                sendingRequest = false
            }
        }
    }
    
    private func deleteSucceeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            withAnimation {
                deleteDeviceSuccessfully = true
            }
            reload()
            showDeletedAlert()
            vibrate(type: .success)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            dismiss()
        }
    }
    
    private func deleteFailed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            vibrate(type: .error)
            showErrorAlert()
            withAnimation {
                sendingDeleteRequest = false
            }
        }
    }
    
    private func showAddedAlert() {
        alertTitle = "Device".localized
        alertDescription = "updated".localized
        alertImage = Image(systemName: "checkmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingSubtileAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingSubtileAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingSubtileAlert = false
                }
            }
        }
    }
    
    private func showErrorAlert() {
        alertTitle = "Error".localized
        alertDescription = "Action failed".localized
        alertImage = Image(systemName: "wifi.slash")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingSubtileAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingSubtileAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingSubtileAlert = false
                }
            }
        }
    }
    
    private func showDeletedAlert() {
        alertTitle = "Device".localized
        alertDescription = "deleted".localized
        alertImage = Image(systemName: "checkmark.circle.fill")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingSubtileAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingSubtileAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingSubtileAlert = false
                }
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.dismissKeyboard()
    }
    
    private func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
