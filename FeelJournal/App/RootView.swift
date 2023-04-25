//
//  RootView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/10/22.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView(
                    presenter: Provider.provideHomePresenter()
                )
            }.tabItem {
                Label("My Journal", systemImage: "book.fill")
            }

            NavigationView {
                AnalyticsView(
                    presenter: Provider.provideAnalyticsPresenter()
                )
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
