//
//  EventPublisher.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 06/03/23.
//

import Foundation
import Combine

final class EventPublisher {
    init() {}
    
    static let shared = EventPublisher()

    func journalPublisher() -> AnyPublisher<JournalEvent, Never> {
        journalSubject
            .eraseToAnyPublisher()
    }
    
    let journalSubject = PassthroughSubject<JournalEvent, Never>()
}

extension EventPublisher {
    enum JournalEvent {
        case refreshJournalList
    }
}
