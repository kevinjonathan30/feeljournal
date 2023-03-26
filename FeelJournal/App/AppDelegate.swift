//
//  AppDelegate.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 15/03/23.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlytics
import FirebasePerformance

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
