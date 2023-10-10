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
    @State private var selectedItem = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedItem) {
                provideJournalTab()
                provideAnalyticsTab()
            }
        }
        .onChange(of: selectedItem) { _ in
            NavigationController.popToRoot()
        }
    }
}

extension FeelJournalApp {
    private func provideJournalTab() -> some View {
        RootView(selectedTab: 0)
            .tag(0)
            .tabItem {
                Label("My Journal", systemImage: "book.fill")
            }
    }
    
    private func provideAnalyticsTab() -> some View {
        RootView(selectedTab: 1)
            .tag(1)
            .tabItem {
                Label("Analytics", systemImage: "chart.xyaxis.line")
            }
    }
}
