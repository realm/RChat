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
    @Environment(\.realm) var userRealm
    var conversation: Conversation?
    var isPreview = false
    
    let padding: CGFloat = 8
    
    var body: some View {
        VStack {
            if let conversation = conversation {
                if isPreview {
                    ChatRoomBubblesView(conversation: conversation, isPreview: isPreview)
                } else {
                    ChatRoomBubblesView(conversation: conversation)
                        .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "conversation=\(conversation.id)"))
                }
            }
            Spacer()
        }
        .navigationBarTitle(conversation?.displayName ?? "Chat", displayMode: .inline)
        .padding(.horizontal, padding)
        .onAppear(perform: clearUnreadCount)
        .onDisappear(perform: clearUnreadCount)
    }
    
    private func clearUnreadCount() {
        if let conversationId = conversation?.id {
            if let conversation = state.user?.conversations.first(where: { $0.id == conversationId }) {
                do {
                    try userRealm.write {
                        conversation.unreadCount = 0
                        print("Reset unreadCount")
                    }
                } catch {
                    print("Unable to clear chat unread count")
                }
            }
        }
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        Realm.bootstrap()
        
        return AppearancePreviews(
            Group {
                NavigationView {
                    ChatRoomView(conversation: .sample, isPreview: true)
                }
            }
        )
        .environmentObject(AppState.sample)
    }
}
