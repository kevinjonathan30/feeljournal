//
//  FeelJournalApp.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

@main
struct FeelJournalApp: App {    
    // Presenter
    let homePresenter = HomePresenter(homeUseCase: Provider().provideHome())
    let addJournalPresenter = AddJournalPresenter(addJournalUseCase: Provider().provideAddJournal())
    let analyticsPresenter = AnalyticsPresenter(analyticsUseCase: Provider().provideAnalytics())
}

extension FeelJournalApp {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ViewRouter(router: NavigationController.router) { path in
                    switch path {
                    case .root:
                        RootView()
                    case .addJournal:
                        AddJournalView(presenter: addJournalPresenter)
                    case .journalDetail(let journal):
                        JournalDetailView(journal: journal)
                    }
                }
            }
            .environmentObject(homePresenter)
            .environmentObject(analyticsPresenter)
        }
    }
}
