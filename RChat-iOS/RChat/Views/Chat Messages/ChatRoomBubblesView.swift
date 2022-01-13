//
//  ChatRoomBubblesView.swift
//  RChat
//
//  Created by Andrew Morgan on 02/02/2021.
//

import SwiftUI
import RealmSwift

struct ChatRoomBubblesView: View {
    @EnvironmentObject var state: AppState
    @ObservedResults(ChatMessage.self, sortDescriptor: SortDescriptor(keyPath: "timestamp", ascending: true)) var chats
    @Environment(\.realm) var realm
    
    @ObservedRealmObject var user: User
    var conversation: Conversation?
    var isPreview = false
    
    @State private var realmChatsNotificationToken: NotificationToken?
    @State private var latestChatId = ""
    
    private enum Dimensions {
        static let padding: CGFloat = 8
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { (proxy: ScrollViewProxy) in
                    VStack {
                        ForEach(chats) { chatMessage in
                            ChatBubbleView(chatMessage: chatMessage,
                                           authorName: chatMessage.author != user.userName ? chatMessage.author : nil,
                                           isPreview: isPreview)
                        }
                    }
                    .onAppear {
                        scrollToBottom()
                        withAnimation(.linear(duration: 0.2)) {
                            proxy.scrollTo(latestChatId, anchor: .bottom)
                        }
                    }
                    .onChange(of: latestChatId) { target in
                        withAnimation {
                            proxy.scrollTo(target, anchor: .bottom)
                        }
                    }
                }
            }
            Spacer()
            if isPreview {
                ChatInputBox(user: user, send: sendMessage, focusAction: scrollToBottom)
            } else {
                ChatInputBox(user: user, send: sendMessage, focusAction: scrollToBottom)
            }
        }
        .navigationBarTitle(conversation?.displayName ?? "Chat", displayMode: .inline)
        .padding(.horizontal, Dimensions.padding)
        .onAppear { loadChatRoom() }
        .onDisappear { closeChatRoom() }
    }
    
    private func loadChatRoom() {
        scrollToBottom()
        setSubscription()
        realmChatsNotificationToken = chats.thaw()?.observe { _ in
            scrollToBottom()
        }
    }
    
    private func closeChatRoom() {
        if let token = realmChatsNotificationToken {
            token.invalidate()
        }
    }
    
    private func sendMessage(chatMessage: ChatMessage) {
        guard let conversataionString = conversation else {
            print("comversation not set")
            return
        }
        chatMessage.conversationId = conversataionString.id
        $chats.append(chatMessage)
    }
    
    private func scrollToBottom() {
        latestChatId = chats.last?._id ?? ""
    }
    
    private func setSubscription() {
        if let subscriptions = realm.subscriptions, let conversation = conversation {
            print("ChatRoomBubblesView: Currently \(subscriptions.count) subscriptions")
            let subscriptionName = "conversation_\(conversation.id)"
            if subscriptions.first(named: subscriptionName) != nil {
                print("\(subscriptionName) already subscribed, so skipping")
            } else {
                do {
                    try subscriptions.write {
                        subscriptions.append({QuerySubscription<ChatMessage>(name: subscriptionName) { chatMessage in
                            chatMessage.partition == "conversation=\(conversation.id)"
                        }})
                    }
                } catch {
                    state.error = error.localizedDescription
                }
                print("Now \(subscriptions.count) subscriptions")
            }
            print("chats count == \(chats.count)")
        }
    }
}

struct ChatRoomBubblesView_Previews: PreviewProvider {
    static var previews: some View {
        Realm.bootstrap()
        
        return AppearancePreviews(ChatRoomBubblesView(user: .sample, isPreview: true))
            .environmentObject(AppState.sample)
    }
}
