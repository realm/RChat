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
    
    @State private var realmUserNotificationToken: NotificationToken?
    @State private var realmChatsterNotificationToken: NotificationToken?
    
    // TODO: Remove if possible
    @State var lastSync: Date?
    @State private var conversation: Conversation?
    @State var showConversation = false
    @State var showingAddChat = false
    
    private let animationDuration = 0.5
    private let sortDescriptors = [
        SortDescriptor(keyPath: "unreadCount", ascending: false),
        SortDescriptor(keyPath: "displayName", ascending: true)
    ]
    
    var body: some View {
        VStack {
            // TODO: Do we still need to use Freeze?
            if let conversations = state.user?.conversations.freeze().sorted(by: sortDescriptors) {
                List {
                    ForEach(conversations) { conversation in
                        Button(action: {
                            self.conversation = conversation
                            showConversation.toggle()
                        }) {
                        ConversationCardView(
                            conversation: conversation,
                            lastSync: lastSync)
                        }
                    }
                }
                .animation(.easeIn(duration: animationDuration))
                Button(action: { showingAddChat.toggle() }) {
                    Text("New Chat Room")
                }
                .disabled(showingAddChat)
            }
            Spacer()
            if let lastSync = lastSync {
                LastSync(date: lastSync)
            }
            NavigationLink(
                destination: ChatRoomView(conversation: conversation),
                isActive: $showConversation) { EmptyView() }
        }
        .sheet(isPresented: $showingAddChat) {
            // TODO: Not clear why we need to pass in the environmentObject, appears that it may
            // be a bug – should test again in the future.
            NewConversationView()
                .environmentObject(state)
        }
        .onAppear { watchRealms() }
        .onDisappear { stopWatching() }
    }
    
    private func watchRealms() {
        if let userRealm = state.userRealm {
            realmUserNotificationToken = userRealm.observe {_, _ in
                lastSync = Date()
            }
        }
        if let chatsterRealm = state.chatsterRealm {
            realmChatsterNotificationToken = chatsterRealm.observe { _, _ in
                lastSync = Date()
            }
        }
    }
    
    private func stopWatching() {
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
