//
//  RootView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

struct RootView: View {
    // Presenter
    @EnvironmentObject var homePresenter: HomePresenter
    @EnvironmentObject var analyticsPresenter: AnalyticsPresenter
}

extension RootView {
    var body: some View {
        TabView {
            NavigationView {
                HomeView(presenter: homePresenter)
            }.tabItem {
                Label("My Journal", systemImage: "book.fill")
            }

            NavigationView {
                AnalyticsView(presenter: analyticsPresenter)
            }.tabItem {
                Label("Analytics", systemImage: "chart.xyaxis.line")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
