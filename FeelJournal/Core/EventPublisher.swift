//
//  EventPublisher.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 06/03/23.
//

import Foundation
import Combine

final class EventPublisher {
    static let shared = EventPublisher()
    
    let journalSubject = PassthroughSubject<JournalEvent, Never>()
    
    func journalPublisher() -> AnyPublisher<JournalEvent, Never> {
        journalSubject.eraseToAnyPublisher()
    }
    
    private init() {}
}

extension EventPublisher {
    enum JournalEvent {
        case refreshJournalList
    }
}
