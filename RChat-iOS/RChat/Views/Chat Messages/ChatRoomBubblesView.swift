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
    @FetchRealmResults(ChatMessage.self, sortDescriptor: SortDescriptor(keyPath: "timestamp", ascending: true)) var chats
//    @Environment(\.realm) var chatRealm
    
    var conversation: Conversation?
    
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
                                           author: findChatster(userName: chatMessage.author))
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
            ChatInputBox(send: sendMessage, focusAction: scrollToBottom)
        }
        .navigationBarTitle(conversation?.displayName ?? "Chat", displayMode: .inline)
        .padding(.horizontal, Dimensions.padding)
        .onAppear { loadChatRoom() }
        .onDisappear { closeChatRoom() }
    }
    
    private func loadChatRoom() {
        clearUnreadCount()
        scrollToBottom()
        realmChatsNotificationToken = chats.thaw()?.observe { _ in
            scrollToBottom()
        }
    }
    
    private func closeChatRoom() {
        clearUnreadCount()
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
            $chats.append(chatMessage)
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
