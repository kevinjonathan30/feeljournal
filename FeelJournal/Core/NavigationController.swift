//
//  NavigationController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/02/23.
//

import UIKit

struct NavigationController {
    static private var router = Router<Path>(root: .root)
    
    static func getRouter() -> Router<Path> {
        return router
    }
    
    static func push(_ path: Path) {
        router.push(path)
    }
    
    static func pop() {
        router.pop()
    }
    
    static func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case "addJournal":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                router.push(.addJournal)
            }
        default:
            break
        }
    }
}
