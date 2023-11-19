//
//  NavigationController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/02/23.
//

import UIKit

struct NavigationController {
    static private var selectedTab: TabState = .home
    static private var homeRouter = Router<Path>(root: .root)
    static private var analyticsRouter = Router<Path>(root: .root)
    
    static func setSelectedTab(newSelectedTab: TabState) {
        selectedTab = newSelectedTab
    }
    
    static func getRouter() -> Router<Path> {
        switch selectedTab {
        case .home:
            return homeRouter
        case .analytics:
            return analyticsRouter
        }
    }
    
    static func push(_ path: Path) {
        getRouter().push(path)
    }
    
    static func pop() {
        getRouter().pop()
    }
    
    static func popToRoot() {
        getRouter().popToRoot()
    }
    
    static func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case "addJournal":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                getRouter().push(.addJournal)
            }
        default:
            break
        }
    }
}
