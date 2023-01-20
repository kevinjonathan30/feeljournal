//
//  AddJournalInteractor.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import Combine

protocol AddJournalUseCase {
    func addJournal(journal: JournalModel) -> AnyPublisher<Bool, Error>
}

class AddJournalInteractor: AddJournalUseCase {
    private let repository: FeelJournalRepositoryProtocol
    
    init(repository: FeelJournalRepositoryProtocol) {
        self.repository = repository
    }
    
    func addJournal(journal: JournalModel) -> AnyPublisher<Bool, Error> {
        return repository.addJournal(from: journal)
    }
}
