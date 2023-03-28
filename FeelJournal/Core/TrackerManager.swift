//
//  TrackerManager.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 28/03/23.
//

import Foundation
import FirebaseCrashlytics
import AppTrackingTransparency

struct TrackerManager {
    static func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
            case .denied:
                Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
            default:
                Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
            }
        }
    }
}
