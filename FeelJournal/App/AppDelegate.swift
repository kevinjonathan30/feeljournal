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
    
    // FIXME: Quick Shortcut

//    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
//        if shortcutItem.type == "addJournal" {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                NavigationController.push(.addJournal)
//                completionHandler(true)
//            }
//        } else {
//            completionHandler(false)
//        }
//    }
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
