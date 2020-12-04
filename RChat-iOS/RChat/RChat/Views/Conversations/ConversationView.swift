//
//  ConversationView.swift
//  RChat
//
//  Created by Andrew Morgan on 27/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationView: View {
    @State var conversation: Conversation?
    
    @State var userRealm: Realm?
    @State var chatsterRealm: Realm?
    var body: some View {
        VStack {
            if let conversation = conversation {
                ChatRoomView(conversation: conversation)
            } else {
                NewConversationView(conversation: $conversation, userRealm: userRealm)
            }
        }
            .onAppear { initData() }
            .onDisappear { stopWatching() }
    }

    func initData() {
        
    }
    
    func stopWatching() {
        
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ConversationView()
                ConversationView(conversation: .sample)
//                ConversationView(userRealm: .sample, chatsterRealm: .sample)
//                ConversationView(conversation: .sample, userRealm: .sample, chatsterRealm: .sample)
            }
        )
    }
}
