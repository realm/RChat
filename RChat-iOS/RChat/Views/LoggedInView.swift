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
    
    @ObservedResults(User.self) var users
    
    // TODO: See if can remove this
    @State private var isWaiting = true
    @State private var showingProfileView = false
    
    var body: some View {
        ZStack {
            if let user = users.first {
                if showingProfileView {
                    SetUserProfileView(user: user, isPresented: $showingProfileView)
                } else {
                    ConversationListView(user: user)
                        .navigationBarItems(
                            trailing: state.loggedIn && !state.shouldIndicateActivity ? UserAvatarView(
                                photo: user.userPreferences?.avatarImage,
                                online: true) { showingProfileView.toggle() } : nil
                        )
                }
                if isWaiting {
                    ProgressView()
                        .onAppear(perform: waitABit)
                }
            }
        }
        .navigationBarTitle("Chats", displayMode: .inline)
    }
    
    private func waitABit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isWaiting = false
        }
    }
    
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
            .environmentObject(AppState.sample)
    }
}
