//
//  ViewRouter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import SwiftUI

/// Used to bridge between views and the router
struct ViewRouter<T: Hashable, Content: View>: View {
    @ObservedObject var router: Router<T>
    @ViewBuilder var buildView: (T) -> Content
    
    var body: some View {
        NavigationStack(path: $router.paths) {
            buildView(router.root)
            .navigationDestination(for: T.self) { path in
                buildView(path)
            }
        }
        .environmentObject(router)
    }
}
