//
//  ConversationView.swift
//  RChat
//
//  Created by Andrew Morgan on 27/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationView: View {
    @EnvironmentObject var state: AppState
    let conversation: Conversation?
    
    var body: some View {
        VStack {
            if let conversation = conversation {
                ChatRoomView(conversation: conversation)
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
            // TODO: Fix previews
            Group {
//                ConversationView()
//                ConversationView(conversation: .constant(.sample))
//                ConversationView(userRealm: .sample, chatsterRealm: .sample)
//                ConversationView(conversation: .sample, userRealm: .sample, chatsterRealm: .sample)
            }
        )
    }
}
