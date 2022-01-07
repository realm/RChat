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
    
//    @ObservedResults(User.self, subscriptions: []) var sumfin
    @ObservedResults(User.self) var users
    @Binding var userID: String?
    
    @State private var showingProfileView = false
    
    var body: some View {
        ZStack {
            if let user = users.first {
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
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView(userID: .constant("Andrew"))
            .environmentObject(AppState.sample)
    }
}
