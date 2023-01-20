//
//  FeelJournalRepository.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import Combine

protocol FeelJournalRepositoryProtocol {
    func getJournalList() -> AnyPublisher<[JournalModel], Error>
    func addJournal(from journal: JournalModel) -> AnyPublisher<Bool, Error>
}

class FeelJournalRepository: NSObject {
    public typealias RestaurantInstance = (LocaleDataSource) -> FeelJournalRepository
    
    fileprivate let locale: LocaleDataSource
    
    private init(locale: LocaleDataSource) {
        self.locale = locale
    }
    
    public static let sharedInstance: RestaurantInstance = { localeRepo in
        return FeelJournalRepository(locale: localeRepo)
    }
}

extension FeelJournalRepository: FeelJournalRepositoryProtocol {
    func getJournalList() -> AnyPublisher<[JournalModel], Error> {
        return self.locale.getJournalList()
            .map { JournalMapper.mapJournalEntityListToModelList(input: $0) }
            .eraseToAnyPublisher()
    }
    
    func addJournal(
        from journal: JournalModel
    ) -> AnyPublisher<Bool, Error> {
        return self.locale.addJournal(
            from: JournalMapper.mapJournalModelToEntity(input: journal)
        ).eraseToAnyPublisher()
    }
}
