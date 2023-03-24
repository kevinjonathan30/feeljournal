//
//  JournalDetailInteractor.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/03/23.
//

import Foundation
import Combine

protocol JournalDetailUseCase {
    func deleteJournal(withId id: String) -> AnyPublisher<Bool, Error>
}

class JournalDetailInteractor: JournalDetailUseCase {
    private let repository: FeelJournalRepositoryProtocol
    
    init(repository: FeelJournalRepositoryProtocol) {
        self.repository = repository
    }
    
    func deleteJournal(withId id: String) -> AnyPublisher<Bool, Error> {
        return repository.deleteJournal(withId: id)
    }
}
