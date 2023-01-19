//
//  HomeInteractor.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import Combine

protocol HomeUseCase {
    func getJournalList() -> AnyPublisher<[JournalModel], Error>
}

class HomeInteractor: HomeUseCase {
    private let repository: FeelJournalRepositoryProtocol
    
    init(repository: FeelJournalRepositoryProtocol) {
        self.repository = repository
    }
    
    func getJournalList() -> AnyPublisher<[JournalModel], Error> {
        return repository.getJournalList()
    }
}