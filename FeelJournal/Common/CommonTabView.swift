//
//  CommonTabView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 18/10/23.
//

import SwiftUI

struct CommonTabView<Content: View>: View {
    @State private var selectedTab: TabState = .home
    var tabItems: [Content]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabItems.indices, id: \.self) { index in
                tabItems[index]
            }
        }
        .onChange(of: selectedTab) { newSelectedTab in
            NavigationController.setSelectedTab(
                newSelectedTab: newSelectedTab
            )
        }
    }
}
