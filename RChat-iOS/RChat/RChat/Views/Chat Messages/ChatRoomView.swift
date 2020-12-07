//
//  ChatRoomView.swift
//  RChat
//
//  Created by Andrew Morgan on 03/12/2020.
//

import RealmSwift
import SwiftUI

struct ChatRoomView: View {
    @EnvironmentObject var state: AppState
    
    var conversation: Conversation
    var chatsterRealm: Realm? // Use to get displayName and avatar
    
    @State var chatRealm: Realm?
    @State var realmChatsterNotificationToken: NotificationToken?
    @State var realmChatsNotificationToken: NotificationToken?
    @State var lastSync: Date?
    @State var chats: Results<ChatMessage>?
    @State private var latestChatId = ""
    
    private enum Dimensions {
        static let padding: CGFloat = 8
    }
    
    var body: some View {
        VStack {
            if let chats = chats {
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
            }
            Spacer()
            ChatInputBox(send: sendMessage, focusAction: scrollToBottom)
            if let lastSync = lastSync {
                LastSync(date: lastSync)
            }
        }
        .padding(.horizontal, Dimensions.padding)
        .onAppear { loadChatRoom() }
        .onDisappear { closeChatRoom() }
    }
    
    func loadChatRoom() {
        if let user = app.currentUser {
            scrollToBottom()
            self.state.shouldIndicateActivity = true
            var realmConfig = user.configuration(partitionValue: "conversation=\(conversation.id)")
            realmConfig.objectTypes = [ChatMessage.self, Photo.self]
            Realm.asyncOpen(configuration: realmConfig)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { result in
                    if case let .failure(error) = result {
                        self.state.error = "Failed to open ChatMessage realm: \(error.localizedDescription)"
                        state.shouldIndicateActivity = false
                    }
                }, receiveValue: { realm in
                    chatRealm = realm
                    chats = realm.objects(ChatMessage.self).sorted(byKeyPath: "timestamp")
                    realmChatsNotificationToken = realm.observe {_, _ in
                        scrollToBottom()
                        lastSync = Date()
                    }
                    if let chatsterRealm = chatsterRealm {
                        realmChatsterNotificationToken = chatsterRealm.observe {_, _ in
                            lastSync = Date()
                        }
                    }
                    scrollToBottom()
                    state.shouldIndicateActivity = false
                })
                .store(in: &self.state.cancellables)
        }
    }
    
    func closeChatRoom() {
        if let token = realmChatsterNotificationToken {
            token.invalidate()
        }
        if let token = realmChatsNotificationToken {
            token.invalidate()
        }
        chatRealm = nil
    }
    
    func findChatster(userName: String?) -> Chatster? {
        guard let chatsterRealm = chatsterRealm else {
            print("No Chatster Realm set") 
            return nil
        }
        guard let userName = userName else {
            return nil
        }
        if userName == state.user?.userName ?? "" {
            // Only need to use the Chatster object if the author isn't the current user
            return nil
        }
        return chatsterRealm.objects(Chatster.self).filter("userName = %@", userName).first
    }
    
    func sendMessage(text: String, photo: Photo?) {
        let chatMessage = ChatMessage(conversationId: conversation.id, author: state.user?.userName ?? "Unknown", text: text, image: photo)
        if let chatRealm = chatRealm {
            do {
                try chatRealm.write {
                    chatRealm.add(chatMessage)
                }
            } catch {
                state.error = "Unable to open Realm write transaction"
            }
        } else {
            state.error = "Cannot save chat message as realm is not set"
        }
    }
    
    func scrollToBottom() {
        latestChatId = chats?.last?._id ?? ""
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                NavigationView {
                    ChatRoomView(conversation: .sample)
                }
            }
        )
        .environmentObject(AppState.sample)
    }
}
