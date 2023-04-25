//
//  AppDelegate.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 15/03/23.
//

import UIKit
import Firebase
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let providerFactory = FeelJournalAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        UNUserNotificationCenter.current().delegate = self
        
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            NavigationController.handleShortcutItem(shortcutItem: shortcutItem)
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Scene Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationManager.handleNotificationTap(identifier: response.notification.request.identifier)
        completionHandler()
    }
}

class FeelJournalAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
    }
}
