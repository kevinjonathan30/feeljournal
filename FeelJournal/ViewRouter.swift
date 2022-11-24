//
//  ViewRouter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/11/22.
//

import SwiftUI

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

enum Path: Hashable {
    case root
    case addJournal
    case journalDetail(String)
}

final class Router<T: Hashable>: ObservableObject {
    @Published var root: T
    @Published var paths: [T] = []

    init(root: T) {
        self.root = root
    }

    func push(_ path: T) {
        paths.append(path)
    }

    func pop() {
        paths.removeLast()
    }

    func updateRoot(root: T) {
        self.root = root
    }

    func popToRoot() {
        paths = []
    }
}
