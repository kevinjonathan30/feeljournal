//
//  AnalyticsInteractor.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 10/02/23.
//

import Foundation
import Combine

protocol AnalyticsUseCase {
    func getJournalList() -> AnyPublisher<[JournalModel], Error>
}

class AnalyticsInteractor: AnalyticsUseCase {
    private let repository: FeelJournalRepositoryProtocol
    
    init(repository: FeelJournalRepositoryProtocol) {
        self.repository = repository
    }
    
    func getJournalList() -> AnyPublisher<[JournalModel], Error> {
        return repository.getJournalList(query: "")
    }
}
