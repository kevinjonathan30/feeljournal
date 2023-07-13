//
//  NotificationManager.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 25/03/23.
//

import Foundation
import UserNotifications

struct NotificationManager {
    // Request user authorization for notifications
    static func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification authorization granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Schedule daily notification at user-selected time
    static func scheduleNotification(notificationTimeString: String) {
        guard let date = DateHelper.dateFormatter.date(from: notificationTimeString) else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Write in your journal"
        content.body = "Take a few minutes to write down your thoughts and feelings."
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "journalReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Cancel any scheduled notifications
    static func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["journalReminder"])
    }
    
    static func handleNotificationTap(identifier: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            switch identifier {
            case "journalReminder":
                NavigationController.push(.addJournal)
            default:
                break
            }
        }
    }
}
