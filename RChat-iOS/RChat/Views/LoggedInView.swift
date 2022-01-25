//
//  LoggedInView.swift
//  RChat
//
//  Created by Andrew Morgan on 05/01/2022.
//

import SwiftUI
import RealmSwift

struct LoggedInView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.realm) var realm
    
    @ObservedResults(User.self) var users
    @Binding var userID: String?
    
    @State private var showingProfileView = false
    
    var body: some View {
        ZStack {
            if let user = users.first {
                VStack {
                    Text("Found \(users.count) users")
                    Text("User = \(user.userName)")
                }
                if showingProfileView {
                    SetUserProfileView(user: user, isPresented: $showingProfileView, userID: $userID)
                } else {
                    ConversationListView(user: user)
                        .navigationBarItems(
                            trailing: state.loggedIn && !state.shouldIndicateActivity ? UserAvatarView(
                                photo: user.userPreferences?.avatarImage,
                                online: true) { showingProfileView.toggle() } : nil
                        )
                }
            }
        }
        .navigationBarTitle("Chats", displayMode: .inline)
        .onAppear(perform: setSubscription)
    }
    
    private func setSubscription() {
        let subscriptions = realm.subscriptions
        subscriptions.write {
            if let currentSubscription = subscriptions.first(named: "user_id") {
                print("Replacing subscription for user_id")
                currentSubscription.update(toType: User.self) { user in
                    user._id == userID!
                }
            } else {
                print("Appending subscription for user_id")
                subscriptions.append(QuerySubscription<User>(name: "user_id") { user in
                    user._id == userID!
                })
            }
        }
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView(userID: .constant("Andrew"))
            .environmentObject(AppState.sample)
    }
}
