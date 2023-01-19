//
//  ViewRouter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/11/22.
//

import SwiftUI

/// Router class with many utilities
final class Router<T: Hashable>: ObservableObject {
    @Published var root: T
    @Published var paths: [T] = []

    init(root: T) {
        self.root = root
    }
    
    /// Pushes a new screen
    /// - Parameter path: Router path
    func push(_ path: T) {
        paths.append(path)
    }
    
    /// Pop from current screen, go back to previous screen
    func pop() {
        paths.removeLast()
    }
    
    /// Update the current screen root
    /// - Parameter root: screen path
    func updateRoot(root: T) {
        self.root = root
    }
    
    /// Quickly pop from current screen to the root screen
    func popToRoot() {
        paths = []
    }
}
