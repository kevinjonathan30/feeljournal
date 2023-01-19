//
//  RootView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: Router<Path>
    
    // Presenter
    @EnvironmentObject var homePresenter: HomePresenter
}

extension RootView {
    var body: some View {
        TabView {
            HomeView(presenter: homePresenter)
                .tabItem {
                    Label("My Journal", systemImage: "book.fill")
                }

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie.fill")
                }
        }.navigationTitle("FeelJournal")
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}