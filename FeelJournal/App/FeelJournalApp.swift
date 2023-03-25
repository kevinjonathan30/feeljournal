//
//  FeelJournalApp.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

@main
struct FeelJournalApp: App {
    // AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Presenter
    let homePresenter = HomePresenter(homeUseCase: Provider().provideHome())
    let addJournalPresenter = AddJournalPresenter(addJournalUseCase: Provider().provideAddJournal())
    let analyticsPresenter = AnalyticsPresenter(analyticsUseCase: Provider().provideAnalytics())
    let journalDetailPresenter = JournalDetailPresenter(journalDetailUseCase: Provider().provideJournalDetail())
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
                        JournalDetailView(presenter: journalDetailPresenter, journal: journal)
                    case .settings:
                        SettingsView()
                    }
                }
            }
            .environmentObject(homePresenter)
            .environmentObject(analyticsPresenter)
        }
    }
}
