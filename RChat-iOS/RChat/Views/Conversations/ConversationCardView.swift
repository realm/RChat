//
//  ConversationCardView.swift
//  RChat
//
//  Created by Andrew Morgan on 26/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationCardView: View {

    let conversation: Conversation
    var isPreview = false
    
    var body: some View {
        VStack {
            if isPreview {
                ConversationCardContentsView(conversation: conversation)
            } else {
                ConversationCardContentsView(conversation: conversation)
                    .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "all-users=all-the-users"))
            }
        }
    }
}

struct ConversationCardView_Previews: PreviewProvider {
    static var previews: some View {
        Realm.bootstrap()
        
        return AppearancePreviews(
            ConversationCardView(conversation: .sample, isPreview: true)
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
