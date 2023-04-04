//
//  SettingsView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 25/03/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isScheduled") var isScheduled = false
    @AppStorage("notificationTimeString") var notificationTimeString = ""
    
    var body: some View {
        List {
            Section(header: Text("Journal Reminder")) {
                Toggle("Daily Reminder", isOn: $isScheduled)
                    .onChange(of: isScheduled) { isScheduled in
                        handleIsScheduledChange(isScheduled: isScheduled)
                    }
                
                if isScheduled {
                    DatePicker("Notification Time", selection: Binding(
                        get: {
                            DateHelper.dateFormatter.date(from: notificationTimeString) ?? Date()
                        },
                        set: {
                            notificationTimeString = DateHelper.dateFormatter.string(from: $0)
                            handleNotificationTimeChange()
                        }
                    ), displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: Handler

private extension SettingsView {
    private func handleIsScheduledChange(isScheduled: Bool) {
        if isScheduled {
            NotificationManager.requestNotificationAuthorization()
            NotificationManager.scheduleNotification(notificationTimeString: notificationTimeString)
        } else {
            NotificationManager.cancelNotification()
        }
    }
    
    private func handleNotificationTimeChange() {
        NotificationManager.cancelNotification()
        NotificationManager.requestNotificationAuthorization()
        NotificationManager.scheduleNotification(notificationTimeString: notificationTimeString)
    }
}

// MARK: Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
