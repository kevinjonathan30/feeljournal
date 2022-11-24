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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ViewRouter(router: router) { path in
                    switch path {
                    case .root: RootView()
                    case .addJournal: AddJournalView()
                    case .journalDetail(let title): JournalDetailView(title: title)
                    }
                }
            }.environmentObject(router)
        }
    }
}
