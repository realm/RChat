//
//  LogoutButton.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift
import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var state: AppState
    @Environment(\.realm) var realm
    
    @ObservedRealmObject var user: User
    @Binding var userID: String?
    var action: () -> Void = {}
    
    @State private var isConfirming = false
    
    var body: some View {
        Button("Log Out") { isConfirming = true }
        .confirmationDialog("Are you that you want to logout",
                            isPresented: $isConfirming) {
            Button("Confirm Logout", role: .destructive, action: logout)
            Button("Cancel", role: .cancel) {}
        }
        .disabled(state.shouldIndicateActivity)
    }
    
    private func logout() {
        state.shouldIndicateActivity = true
        action()
        // TODO: Find a way that this gets synced to backend
        $user.presenceState.wrappedValue = .offLine
        // TODO: Is there a way to do this without causing issues when users log out back in on the same devoce?
        // clearSubscriptions()
        app.currentUser?.logOut { _ in
            DispatchQueue.main.async {
                state.shouldIndicateActivity = false
            }
        }
    }
    
    private func clearSubscriptions() {
        let subscriptions = realm.subscriptions
        subscriptions.update {
            subscriptions.removeAll()
        }
    }
    
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            LogoutButton(user: User(), userID: .constant("Andrew"))
                .environmentObject(AppState())
                .previewLayout(.sizeThatFits)
                .padding()
        )
    }
}
