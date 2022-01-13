//
//  ConversationCardContentsView.swift
//  RChat
//
//  Created by Andrew Morgan on 26/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationCardContentsView: View {
    @EnvironmentObject var state: AppState
    @ObservedResults(Chatster.self) var chatsters
    @Environment(\.realm) var realm
    
    let conversation: Conversation
    
    private struct Dimensions {
        static let mugWidth: CGFloat = 110
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 1
        static let padding: CGFloat = 5
    }
    
    var chatMembers: [Chatster] {
        var chatsterList = [Chatster]()
        for member in conversation.members {
            chatsterList.append(contentsOf: chatsters.filter("userName = %@", member.userName))
        }
        return chatsterList
    }
    
    var body: some View {
        HStack {
            MugShotGridView(members: chatMembers)
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
        .onAppear(perform: setSubscription)
    }
    
    private func setSubscription() {
        if let subscriptions = realm.subscriptions {
            print("ConversationCardContentsView: Currently \(subscriptions.count) subscriptions")
            if subscriptions.first(named: "all_chatsters") != nil {
                print("all_chatsters already subscribed, so skipping")
            } else {
                do {
                    try subscriptions.write {
                        subscriptions.append({QuerySubscription<Chatster>(name: "all_chatsters") { chatster in
                            chatster.userName != ""
                        }})
                    }
                } catch {
                    state.error = error.localizedDescription
                }
                if let subscriptions = realm.subscriptions {
                    print("Now \(subscriptions.count) subscriptions")
                }
            }
            print("chatsters count == \(chatsters.count)")
        }
    }
}

struct ConversationCardContentsView_Previews: PreviewProvider {
    static var previews: some View {
        Realm.bootstrap()

        return AppearancePreviews(
            ForEach(Conversation.samples) { conversation in
                ConversationCardContentsView(conversation: conversation)
            }
        )
        .previewLayout(.sizeThatFits)
    }
}
