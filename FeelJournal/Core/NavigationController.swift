//
//  NavigationController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/02/23.
//

import Foundation

struct NavigationController {
    static var router = Router<Path>(root: .root)
    
    static func push(_ path: Path) {
        router.push(path)
    }
    
    static func pop() {
        router.pop()
    }
}
