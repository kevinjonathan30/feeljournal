//
//  HomeInteractor.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import Combine

protocol HomeUseCase {
    func getJournalList(query: String) -> AnyPublisher<[JournalModel], Error>
    func deleteJournal(withId id: String) -> AnyPublisher<Bool, Error>
}

class HomeInteractor: HomeUseCase {
    private let repository: FeelJournalRepositoryProtocol
    
    init(repository: FeelJournalRepositoryProtocol) {
        self.repository = repository
    }
    
    func getJournalList(query: String = "") -> AnyPublisher<[JournalModel], Error> {
        return repository.getJournalList(query: query)
    }
    
    func deleteJournal(withId id: String) -> AnyPublisher<Bool, Error> {
        return repository.deleteJournal(withId: id)
    }
}
