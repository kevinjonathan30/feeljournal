//
//  RootView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

struct RootView: View {
    var selectedTab: TabState = .home
    
    var body: some View {
        NavigationStack {
            ViewRouter(router: NavigationController.getRouter()) { path in
                switch path {
                case .root:
                    determineRootView(selectedTab: selectedTab)
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

extension RootView {
    @ViewBuilder 
    func determineRootView(selectedTab: TabState) -> some View {
        switch selectedTab {
        case .home:
            HomeView(
                presenter: Provider.provideHomePresenter()
            )
        case .analytics:
            AnalyticsView(
                presenter: Provider.provideAnalyticsPresenter()
            )
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(selectedTab: .home)
    }
}
