//
//  ConversationCardContentsView.swift
//  RChat
//
//  Created by Andrew Morgan on 26/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationCardContentsView: View {
    let conversation: Conversation
    let chatsters: Results<Chatster>
    
    private struct Dimensions {
        static let mugWidth: CGFloat = 200
        static let cornerRadius: CGFloat = 16
        static let lineWidth: CGFloat = 4
    }
    
    var body: some View {
        HStack {
            MugShotGridView(photos: chatsters.compactMap { $0.avatarImage })
                .frame(width: Dimensions.mugWidth)
            VStack(alignment: .leading) {
                Text(conversation.displayName)
                Text(conversation.unreadCount == 0 ? "" :
                        "\(conversation.unreadCount) new \(conversation.unreadCount == 1 ? "message" : "messages")")
                    .fontWeight(conversation.unreadCount > 0 ? .bold : .regular)
                    .italic()
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: Dimensions.cornerRadius)
                .stroke(Color.gray, lineWidth: Dimensions.lineWidth)
        )

    }
}

struct ConversationCardContentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            ConversationCardContentsView(
                conversation: .sample, chatsters: [.sample, .sample, .sample]
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
