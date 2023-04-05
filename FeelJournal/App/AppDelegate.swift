//
//  AppDelegate.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 15/03/23.
//

import UIKit
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let providerFactory = FeelJournalAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        UNUserNotificationCenter.current().delegate = self
        
        FirebaseApp.configure()
        return true
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
