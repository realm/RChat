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
    @Binding var conversationId: String?
    @Binding var showConversation: Bool
    
    @State var realmUserNotificationToken: NotificationToken?
    @State var realmChatsterNotificationToken: NotificationToken?
    @State var lastSync: Date?
    
    private let sortDescriptors = [
        SortDescriptor(keyPath: "unreadCount", ascending: false),
        SortDescriptor(keyPath: "displayName", ascending: true)
    ]
    
    var body: some View {
        VStack {
            if let conversations = state.user?.conversations {
                if let chatsterRealm = chatsterRealm {
                    if let userRealm = userRealm {
                        List {
                            ForEach(conversations.sorted(by: sortDescriptors)) { conversation in
                                // TODO: Why is ! needed?
                                Button(action: {
                                    conversationId = conversation.id
                                    showConversation.toggle()
                                }) {
                                ConversationCardView(
                                    realm: chatsterRealm,
                                    conversation: userRealm.resolve(ThreadSafeReference(to: conversation))!)
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
//            NavigationLink(
//                destination: ConversationView(
//                    conversationId: conversationId,
//                    userRealm: userRealm,
//                    chatsterRealm: chatsterRealm),
//                isActive: $showConversation) { EmptyView() }
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
//                print("Realm Chatster file location: \(realm.configuration.fileURL!.path)")
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
        realmConfig.objectTypes = [User.self, UserPreferences.self, Conversation.self, Photo.self]
        Realm.asyncOpen(configuration: realmConfig)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    self.state.error = "Failed to open User realm: \(error.localizedDescription)"
                    state.shouldIndicateActivity = false
                }
            }, receiveValue: { realm in
                print("Realm User file location: \(realm.configuration.fileURL!.path)")
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

//struct ConversationListViewPreviews: PreviewProvider {
//    static var previews: some View {
//        AppearancePreviews(
//            ConversationListView(lastSync: Date())
//        )
//        .environmentObject(AppState.sample)
//    }
//}
