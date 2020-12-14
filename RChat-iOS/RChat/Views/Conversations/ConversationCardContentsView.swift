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
    let chatsters: [Chatster]
    
    private struct Dimensions {
        static let mugWidth: CGFloat = 110
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 1
        static let padding: CGFloat = 5
    }
    
    var body: some View {
        HStack {
            MugShotGridView(members: chatsters)
                .frame(width: Dimensions.mugWidth)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(conversation.displayName)
                    .fontWeight(conversation.unreadCount > 0 ? .bold : .regular)
                CaptionLabel(title: conversation.unreadCount == 0 ? "" :
                        "\(conversation.unreadCount) new \(conversation.unreadCount == 1 ? "message" : "messages")")
            }
            Spacer()
        }
        .padding(Dimensions.padding)
        .overlay(
            RoundedRectangle(cornerRadius: Dimensions.cornerRadius)
                .stroke(Color.gray, lineWidth: Dimensions.lineWidth)
        )
    }
}

struct ConversationCardContentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            ForEach(Conversation.samples) { conversation in
                ConversationCardContentsView(conversation: conversation, chatsters: [.sample, .sample2, .sample3, .sample, .sample2, .sample3])
            }
        )
        .previewLayout(.sizeThatFits)
    }
}
