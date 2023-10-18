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
            CommonTabView(
                tabItems: [
                    provideTab(
                        selectedTab: .home,
                        alt: "My Journal",
                        systemImage: "book.fill"
                    ),
                    provideTab(
                        selectedTab: .analytics,
                        alt: "Analytics",
                        systemImage: "chart.xyaxis.line"
                    )
                ]
            )
        }
    }
}

extension FeelJournalApp {
    private func provideTab(
        selectedTab: TabState,
        alt: String,
        systemImage: String
    ) -> some View {
        RootView(selectedTab: selectedTab)
            .tag(selectedTab)
            .tabItem {
                Label(alt, systemImage: systemImage)
            }
    }
}
