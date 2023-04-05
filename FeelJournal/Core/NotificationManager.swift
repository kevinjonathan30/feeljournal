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
        let content = UNMutableNotificationContent()
        content.title = "Write in your journal"
        content.body = "Take a few minutes to write down your thoughts and feelings."
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.hour = calendar.component(.hour, from: DateHelper.dateFormatter.date(from: notificationTimeString) ?? Date())
        dateComponents.minute = calendar.component(.minute, from: DateHelper.dateFormatter.date(from: notificationTimeString) ?? Date())
        
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
