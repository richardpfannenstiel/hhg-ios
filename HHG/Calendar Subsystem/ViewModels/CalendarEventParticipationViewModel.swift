//
//  CalendarEventParticipationViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.09.21.
//

import Foundation
import SwiftUI
import Combine

final class CalendarEventParticipationViewModel: ObservableObject {
    
    @Published var participants: [Resident] = []
    
    // MARK: Stored Properties
    
    let eventID: Int
    let previewBubbleLimit = 5
    let showAllParticipants: () -> ()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Computed Properties
    
    var participantsCount: Int {
        participants.count > previewBubbleLimit ? previewBubbleLimit : participants.count
    }
    
    // MARK: Initialization
    
    init(eventID: Int, calendarDetailModel: CalendarDetailViewModel, showAllParticipants: @escaping () -> ()) {
        self.eventID = eventID
        self.showAllParticipants = showAllParticipants
        
        calendarDetailModel.$participants
            .assign(to: \.participants, on: self)
            .store(in: &cancellables)
    }
}
