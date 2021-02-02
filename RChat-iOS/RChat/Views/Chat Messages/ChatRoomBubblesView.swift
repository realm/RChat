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
    
    var conversation: Conversation?
    @ObservedRealmObject var chats: RealmSwift.List<ChatMessage>
    let chatRealm: Realm
    
//    @State private var realmChatsterNotificationToken: NotificationToken?
    @State private var realmChatsNotificationToken: NotificationToken?
    @State private var lastSync: Date?
//    @State private var chats: Results<ChatMessage>?
    @State private var latestChatId = ""
    
    private enum Dimensions {
        static let padding: CGFloat = 8
    }
    
    var body: some View {
        VStack {
//            if let chats = chats {
                ScrollView(.vertical) {
                    ScrollViewReader { (proxy: ScrollViewProxy) in
                        VStack {
                            ForEach(chats.freeze()) { chatMessage in
                                ChatBubbleView(chatMessage: chatMessage,
                                               author: findChatster(userName: chatMessage.author))
                            }
                        }
                        .onAppear {
                            withAnimation {
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
//            }
            Spacer()
            ChatInputBox(send: sendMessage, focusAction: scrollToBottom)
            if let lastSync = lastSync {
                LastSync(date: lastSync)
            }
        }
        .navigationBarTitle(conversation?.displayName ?? "Chat", displayMode: .inline)
        .padding(.horizontal, Dimensions.padding)
        .onAppear { loadChatRoom() }
        .onDisappear { closeChatRoom() }
    }
    
    private func loadChatRoom() {
        clearUnreadCount()
        scrollToBottom()
        realmChatsNotificationToken = chatRealm.observe {_, _ in
            scrollToBottom()
            clearUnreadCount()
            lastSync = Date()
        }
    }
    
    private func closeChatRoom() {
        clearUnreadCount()
//        if let token = realmChatsterNotificationToken {
//            token.invalidate()
//        }
        if let token = realmChatsNotificationToken {
            token.invalidate()
        }
    }
    
    private func clearUnreadCount() {
        if let user = state.user, let realm = state.userRealm, let conversationId = conversation?.id {
            if let conversation = user.conversations.first(where: { $0.id == conversationId }) {
                do {
                    try realm.write {
                        conversation.unreadCount = 0
                    }
                } catch {
                    state.error = "Unable to clear chat unread count"
                }
            }
        }
    }
    
    private func findChatster(userName: String?) -> Chatster? {
        guard let chatsterRealm = state.chatsterRealm else {
            print("No Chatster Realm set")
            return nil
        }
        guard let userName = userName else {
            return nil
        }
        if userName == state.user?.userName ?? "" {
            return nil
        }
        return chatsterRealm.objects(Chatster.self).filter("userName = %@", userName).first
    }
    
    private func sendMessage(text: String, photo: Photo?, location: [Double]) {
        if let conversation = conversation {
            let chatMessage = ChatMessage(conversationId: conversation.id,
                                          author: state.user?.userName ?? "Unknown",
                                          text: text,
                                          image: photo,
                                          location: location)
//            if let chatRealm = chatRealm {
                do {
                    try chatRealm.write {
                        chatRealm.add(chatMessage)
                    }
                } catch {
                    state.error = "Unable to open Realm write transaction"
                }
//            } else {
//                state.error = "Cannot save chat message as realm is not set"
//            }
        }
    }
    
    private func scrollToBottom() {
        latestChatId = chats.last?._id ?? ""
    }
}

//struct ChatRoomBubblesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomBubblesView()
//    }
//}
