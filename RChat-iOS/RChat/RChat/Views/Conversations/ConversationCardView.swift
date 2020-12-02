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
    let conversation: Conversation?
    
    @State var shouldIndicateActivity = false
    
    var chatsters: [Chatster] {
        var chatsterList = [Chatster]()
        if let conversation = conversation {
            let allChatsters = realm.objects(Chatster.self)
            for member in conversation.members {
                chatsterList.append(contentsOf: allChatsters.filter("userName = %@", member.userName))
            }
        }
        return chatsterList
    }
    
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
