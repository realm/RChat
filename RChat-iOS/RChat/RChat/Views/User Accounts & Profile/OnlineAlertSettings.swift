//
//  OnlineAlertSettings.swift
//  RChat
//
//  Created by Andrew Morgan on 25/11/2020.
//

import SwiftUI
import UserNotifications

struct OnlineAlertSettings: View {
    @EnvironmentObject var state: AppState
    
    @AppStorage("shouldRemindOnlineUser") var shouldRemindOnlineUser = false
    @AppStorage("onlineUserReminderHours") var onlineUserReminderHours = 8.0
    
    var body: some View {
        VStack {
            Toggle(isOn: $shouldRemindOnlineUser, label: {
                Text("On-line reminder")
            })
            .onChange(of: shouldRemindOnlineUser, perform: { value in
                if value {
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if !success {
                            shouldRemindOnlineUser = false
                        }
                        if let error = error {
                            state.error = "Failed to enable notifications: \(error.localizedDescription)"
                        }
                    }
                }
            })
            if shouldRemindOnlineUser {
                    Slider(value: $onlineUserReminderHours, in: 1...24, step: 1)
                    Text("Minimized alert in "
                        + "\(Int(onlineUserReminderHours)) \(onlineUserReminderHours == 1 ? "hour" : "hours")")
            }
        }
    }
}

struct OnlineAlertSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            OnlineAlertSettings()
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
