//
//  SettingsView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 25/03/23.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("isScheduled") var isScheduled = false
    @AppStorage("notificationTimeString") var notificationTimeString = ""
    
    // Convert Date to String
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    // Request user authorization for notifications
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification authorization granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Schedule daily notification at user-selected time
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Write in your journal"
        content.body = "Take a few minutes to write down your thoughts and feelings."
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.hour = calendar.component(.hour, from: Self.dateFormatter.date(from: notificationTimeString) ?? Date())
        dateComponents.minute = calendar.component(.minute, from: Self.dateFormatter.date(from: notificationTimeString) ?? Date())
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "journalReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Cancel any scheduled notifications
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["journalReminder"])
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Journal Reminder")) {
                    Toggle("Daily Reminder", isOn: $isScheduled)
                        .onChange(of: isScheduled) { value in
                            if value {
                                requestNotificationAuthorization()
                                scheduleNotification()
                            } else {
                                cancelNotification()
                            }
                        }
                    
                    if isScheduled {
                        DatePicker("Notification Time", selection: Binding(
                            get: { Self.dateFormatter.date(from: notificationTimeString) ?? Date() },
                            set: { notificationTimeString = Self.dateFormatter.string(from: $0) }
                        ), displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

