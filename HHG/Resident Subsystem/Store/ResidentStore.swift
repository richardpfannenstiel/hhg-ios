//
//  ResidentStore.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 09.07.21.
//

import Foundation
import Combine
import SwiftUI

final class ResidentStore: ObservableObject {
    
    @AppStorage("user.authtoken") var authtoken = ""
    
    static let shared = ResidentStore()
    
    @Published var residents: [Resident] = []
    
    private let agent = HTTPAgent.init()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        get()
    }

    private func get() {
        let url = ServerURL.residents.constructedURL
        let body = ["authtoken" : authtoken]
        
        agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[Resident]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .assign(to: \ResidentStore.residents, on: self)
            .store(in: &cancellables)
    }
    
    func reloadResidents() -> AnyPublisher<[Resident], Never> {
        let url = ServerURL.residents.constructedURL
        let body = ["authtoken" : authtoken]
        
        return agent.getJSON(from: url, with: body)
            .catch({ err -> Just<[Resident]> in
                print("Error: ", err)
                return Just([])
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func reload() {
        get()
    }
}
