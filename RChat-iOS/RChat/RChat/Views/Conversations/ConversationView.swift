//
//  ConversationView.swift
//  RChat
//
//  Created by Andrew Morgan on 27/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationView: View {
    @State var conversationId: String?
    
    @State var userRealm: Realm?
    @State var chatsterRealm: Realm?
    var body: some View {
        VStack {
            if let conversationId = conversationId {
                Text("Existing conversation: \(conversationId)")
            } else {
                NewConversationView(conversationId: $conversationId, userRealm: userRealm)
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
                ConversationView(userRealm: .sample, chatsterRealm: .sample)
                ConversationView(conversationId: "My conversation", userRealm: .sample, chatsterRealm: .sample)
            }
        )
    }
}
