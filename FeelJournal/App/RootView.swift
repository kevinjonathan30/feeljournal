//
//  RootView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

struct RootView: View {
    var selectedTab: Int = 0
    
    var body: some View {
        NavigationStack {
            ViewRouter(router: NavigationController.getRouter()) { path in
                switch path {
                case .root:
                    determineRootView(index: selectedTab)
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
    @ViewBuilder func determineRootView(index: Int) -> some View {
        if index == 0 {
            HomeView(
                presenter: Provider.provideHomePresenter()
            )
        } else {
            AnalyticsView(
                presenter: Provider.provideAnalyticsPresenter()
            )
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(selectedTab: 0)
    }
}
