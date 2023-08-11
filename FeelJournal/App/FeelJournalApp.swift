//
//  FeelJournalApp.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

@main
struct FeelJournalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ViewRouter(router: NavigationController.getRouter()) { path in
                    switch path {
                    case .root:
                        RootView()
                    case .addJournal:
                        AddJournalView(
                            presenter: Provider.provideAddJournalPresenter()
                        )
                    case .journalDetail(let journal):
                        JournalDetailView(
                            presenter: Provider.provideJournalDetailPresenter(
                                journal: journal
                            )
                        )
                    case .settings:
                        SettingsView()
                    }
                }
            }
        }
    }
}
