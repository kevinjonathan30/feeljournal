//
//  SceneDelegate.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 25/04/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        NavigationController.handleShortcutItem(shortcutItem: shortcutItem)
        completionHandler(true)
    }
}
