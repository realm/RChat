//
//  ConversationListView
//  RChat
//
//  Created by Andrew Morgan on 25/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationListView: View {
    @EnvironmentObject var state: AppState
    
    @Binding var chatsterRealm: Realm?
    @Binding var userRealm: Realm?
    @Binding var conversation: Conversation?
    @Binding var showConversation: Bool
    
    @State var realmUserNotificationToken: NotificationToken?
    @State var realmChatsterNotificationToken: NotificationToken?
    @State var lastSync: Date?
       
    var body: some View {
        VStack {
            if let conversations = state.user?.conversations.freeze() {
                if let chatsterRealm = chatsterRealm {
                    if userRealm != nil {
                        List {
                            ForEach(conversations) { conversation in
                                Button(action: {
                                    self.conversation = conversation
                                    showConversation.toggle()
                                }) {
                                ConversationCardView(
                                    realm: chatsterRealm,
                                    conversation: conversation)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
            if let lastSync = lastSync {
                LastSync(date: lastSync)
            }
        }
        .onAppear { initData() }
        .onDisappear { stopWatching() }
    }
    
    func initData() {
        if let user = app.currentUser {
            state.shouldIndicateActivity = true
            var realmConfig = user.configuration(partitionValue: "all-users=all-the-users")
            realmConfig.objectTypes = [Chatster.self, Photo.self]
            Realm.asyncOpen(configuration: realmConfig)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    self.state.error = "Failed to open Chatster realm: \(error.localizedDescription)"
                    state.shouldIndicateActivity = false
                }
            }, receiveValue: { realm in
                chatsterRealm = realm
                realmChatsterNotificationToken = realm.observe {_, _ in
                    lastSync = Date()
                }
                watchUserRealm(user: user)
            })
            .store(in: &self.state.cancellables)
        }
    }
    
    func watchUserRealm(user: RealmSwift.User) {
        var realmConfig = user.configuration(partitionValue: "user=\(user.id)")
        realmConfig.objectTypes = [User.self, UserPreferences.self, Conversation.self, Photo.self, Member.self]
        Realm.asyncOpen(configuration: realmConfig)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    self.state.error = "Failed to open User realm: \(error.localizedDescription)"
                    state.shouldIndicateActivity = false
                }
            }, receiveValue: { realm in
                userRealm = realm
                realmUserNotificationToken = realm.observe {_, _ in
                    lastSync = Date()
                }
                state.shouldIndicateActivity = false
            })
            .store(in: &self.state.cancellables)
    }
    
    func stopWatching() {
        if let userToken = realmUserNotificationToken {
            userToken.invalidate()
        }
        if let chatsterToken = realmChatsterNotificationToken {
            chatsterToken.invalidate()
        }
    }
}

struct ConversationListViewPreviews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            ConversationListView(
                chatsterRealm: .constant(.sample),
                userRealm: .constant(.sample),
                conversation: .constant(.sample),
                showConversation: .constant(true),
                lastSync: Date())
        )
        .environmentObject(AppState.sample)
    }
}
