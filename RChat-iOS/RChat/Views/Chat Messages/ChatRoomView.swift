//
//  ChatRoomView.swift
//  RChat
//
//  Created by Andrew Morgan on 03/12/2020.
//

import RealmSwift
import SwiftUI

struct ChatRoomView: View {
    var conversation: Conversation?
    
    let padding: CGFloat = 8
    
    var body: some View {
        VStack {
            if let conversation = conversation {
                ChatRoomBubblesView(
                    conversation: conversation)
                    .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "conversation=\(conversation.id)"))
            }
            Spacer()
        }
        .navigationBarTitle(conversation?.displayName ?? "Chat", displayMode: .inline)
        .padding(.horizontal, padding)
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                NavigationView {
                    ChatRoomView(conversation: .sample)
                }
            }
        )
    }
}
