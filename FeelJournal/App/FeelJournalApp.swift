//
//  FeelJournalApp.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

@main
struct FeelJournalApp: App {
    @ObservedObject var router = Router<Path>(root: .root)
    
    // Presenter
    let homePresenter = HomePresenter(homeUseCase: Provider().provideHome())
    let addJournalPresenter = AddJournalPresenter(addJournalUseCase: Provider().provideAddJournal())
}

extension FeelJournalApp {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ViewRouter(router: router) { path in
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
            .environmentObject(router)
            .environmentObject(homePresenter)
        }
    }
}
