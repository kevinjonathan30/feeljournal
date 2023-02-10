//
//  Provider.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import RealmSwift
import SwiftUI

final class Provider: NSObject {
    override init() {}
    
    private func provideRepository() -> FeelJournalRepositoryProtocol {
        let realm = try? Realm()
        
        let locale: LocaleDataSource = LocaleDataSource.sharedInstance(realm)
        
        return FeelJournalRepository.sharedInstance(locale)
    }
    
    func provideHome() -> HomeUseCase {
        let repository = provideRepository()
        return HomeInteractor(repository: repository)
    }
    
    func provideAddJournal() -> AddJournalUseCase {
        let repository = provideRepository()
        return AddJournalInteractor(repository: repository)
    }
    
    func provideAnalytics() -> AnalyticsUseCase {
        let repository = provideRepository()
        return AnalyticsInteractor(repository: repository)
    }
}
