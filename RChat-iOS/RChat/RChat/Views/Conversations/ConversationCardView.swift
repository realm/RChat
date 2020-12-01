//
//  ConversationCardView.swift
//  RChat
//
//  Created by Andrew Morgan on 26/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationCardView: View {

    let realm: Realm
    @State var conversation: Conversation?
    
    @State var chatsters = [Chatster]()
    @State var shouldIndicateActivity = false
    
    var body: some View {
        if let conversation = conversation {
            ZStack {
                VStack {
                    ConversationCardContentsView(conversation: conversation, chatsters: chatsters)
                }
                if shouldIndicateActivity {
                    OpaqueProgressView("Fetching Conversation")
                }
            }
            .onAppear { initData() }
        }
    }
    
    func initData() {
        if let conversation = conversation {
            shouldIndicateActivity = true
            chatsters = []
            let allChatsters = realm.objects(Chatster.self)
            for member in conversation.members {
                chatsters.append(contentsOf: allChatsters.filter("userName = %@", member.userName))
            }
            shouldIndicateActivity = false
        }
    }
}

struct ConversationCardView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            ConversationCardView(realm: .sample, conversation: .sample)
            .environmentObject(AppState.sample)
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
