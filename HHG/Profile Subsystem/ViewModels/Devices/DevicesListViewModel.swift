//
//  DevicesListViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.03.22.
//

import SwiftUI
import Combine

final class DevicesListViewModel: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    // MARK: Stored Properties
    
    @Published var devices: [Device] = []
    
    @Published var selectedDevice: Device?
    @Published var showingEditDevice = false
    @Published var showingAddDevice = false
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    let dismiss: () -> ()
    
    // MARK: Computed Properties
    
    // MARK: Initializers
    
    init(dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
        get()
    }
    
    // MARK: Methods
    
    private func get() {
        let url = ServerURL.registeredDevices.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[Device]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .assign(to: \.devices, on: self)
            .store(in: &cancellables)
    }
    
    func reload() {
        get()
    }
    
    func edit(_ device: Device) {
        selectedDevice = device
        showingEditDevice = true
    }
    
    func dismissEditDevice() {
        showingEditDevice = false
    }
    
    func add() {
        showingAddDevice = true
    }
    
    func dismissAddDevice() {
        showingAddDevice = false
    }
    
    func sort(lhs: Device, rhs: Device) -> Bool {
        lhs > rhs
    }

}
