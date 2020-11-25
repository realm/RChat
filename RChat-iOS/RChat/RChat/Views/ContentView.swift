//
//  ContentView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var state: AppState

    @AppStorage("shouldRemindOnlineUser") var shouldRemindOnlineUser = false
    @AppStorage("onlineUserReminderHours") var onlineUserReminderHours = 8.0
    
    @State var showingProfileView = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if state.loggedIn {
                        if (state.user != nil) && !state.user!.isProfileSet || showingProfileView {
                            SetProfileView(isPresented: $showingProfileView)
                        } else {
                            Text("Logged in")
                            .navigationBarTitle("RChat", displayMode: .inline)
                            .navigationBarItems(
                                leading: state.loggedIn ? LogoutButton() : nil,
                                trailing: state.loggedIn ? UserProfileButton { showingProfileView.toggle() } : nil
                            )
                        }
                    } else {
                        LoginView()
                    }
                    Spacer()
                    if let error = state.error {
                        Text("Error: \(error)")
                            .foregroundColor(Color.red)
                    }
                }
                if state.shouldIndicateActivity {
                    OpaqueProgressView("Working With Realm")
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            if let user = state.user {
                if user.presenceState == .onLine && shouldRemindOnlineUser {
                    addNotification(timeInHours: Int(onlineUserReminderHours))
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            clearNotifications()
        }
    }
    
    func addNotification(timeInHours: Int) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Still logged in"
            content.subtitle = "You've been offline in the background for " +
                "\(onlineUserReminderHours) \(onlineUserReminderHours == 1 ? "hour" : "hours")"
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 * 3600, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                    if success {
                        addRequest()
                    }
                }
            }
        }
    }
    
    func clearNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ContentView()
                    .environmentObject(AppState())
                Landscape(ContentView()
                            .environmentObject(AppState()))
            }
        )
    }
}
