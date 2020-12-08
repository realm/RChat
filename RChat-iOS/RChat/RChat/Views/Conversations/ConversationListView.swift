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
    
    @State var realmUserNotificationToken: NotificationToken?
    @State var realmChatsterNotificationToken: NotificationToken?
    @State var lastSync: Date?
    @State var conversation: Conversation?
    @State var showConversation = false
    
    private let sortDescriptors = [
        SortDescriptor(keyPath: "unreadCount", ascending: false),
        SortDescriptor(keyPath: "displayName", ascending: true)
    ]
    
    var body: some View {
        VStack {
            if let conversations = state.user?.conversations.freeze().sorted(by: sortDescriptors) {
                List {
                    ForEach(conversations) { conversation in
                        Button(action: {
                            self.conversation = conversation
                            showConversation.toggle()
                        }) {
                        ConversationCardView(
                            conversation: conversation)
                        }
                    }
                }
                .animation(.easeIn(duration: 0.5))
            }
            Spacer()
            if let lastSync = lastSync {
                LastSync(date: lastSync)
            }
            NavigationLink(
                destination: ChatRoomView(conversation: conversation),
                isActive: $showConversation) { EmptyView() }
        }
        .onAppear { watchUserRealm() }
        .onDisappear { stopWatching() }
    }
    
    func watchUserRealm() {
        if let realm = state.userRealm {
            realmUserNotificationToken = realm.observe {_, _ in
                lastSync = Date()
            }
        }
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
        // TODO: Fix preview
        AppearancePreviews(
            ConversationListView(
                lastSync: Date())
        )
        .environmentObject(AppState.sample)
    }
}
