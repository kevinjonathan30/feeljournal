//
//  Provider.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import RealmSwift
import SwiftUI

// MARK: Repository Provider

struct Provider {
    static private func provideRepository() -> FeelJournalRepositoryProtocol {
        let realm = try? Realm()
        
        let locale: LocaleDataSource = LocaleDataSource.sharedInstance(realm)
        
        return FeelJournalRepository.sharedInstance(locale)
    }
}

// MARK: UseCase Provider

extension Provider {
    static private func provideHomeUseCase() -> HomeUseCase {
        let repository = provideRepository()
        return HomeInteractor(repository: repository)
    }
    
    static private func provideAddJournalUseCase() -> AddJournalUseCase {
        let repository = provideRepository()
        return AddJournalInteractor(repository: repository)
    }
    
    static private func provideAnalyticsUseCase() -> AnalyticsUseCase {
        let repository = provideRepository()
        return AnalyticsInteractor(repository: repository)
    }
    
    static private func provideJournalDetailUseCase() -> JournalDetailUseCase {
        let repository = provideRepository()
        return JournalDetailInteractor(repository: repository)
    }
}

// MARK: Presenter Provider

extension Provider {
    static func provideHomePresenter() -> HomePresenter {
        return HomePresenter(
            homeUseCase: provideHomeUseCase()
        )
    }
    
    static func provideAddJournalPresenter() -> AddJournalPresenter {
        return AddJournalPresenter(
            addJournalUseCase: provideAddJournalUseCase()
        )
    }
    
    static func provideAnalyticsPresenter() -> AnalyticsPresenter {
        return AnalyticsPresenter(
            analyticsUseCase: provideAnalyticsUseCase()
        )
    }
    
    static func provideJournalDetailPresenter() -> JournalDetailPresenter {
        return JournalDetailPresenter(
            journalDetailUseCase: provideJournalDetailUseCase()
        )
    }
}
