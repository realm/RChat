//
//  SaveConversationButton.swift
//  RChat
//
//  Created by Andrew Morgan on 10/02/2021.
//

import SwiftUI
import RealmSwift

struct SaveConversationButton: View {
    @EnvironmentObject var state: AppState
    @Environment(\.realm) var userRealm
    
    let name: String
    let members: [String]
    var done: () -> Void = { }
    
    var body: some View {
        Button(action: saveConversation) {
            Text("Save")
        }
    }
    
    private func saveConversation() {
        state.error = nil
        let conversation = Conversation()
        conversation.displayName = name
        guard let userName = state.user?.userName else {
            state.error = "Current user is not set"
            return
        }
        conversation.members.append(Member(userName: userName, state: .active))
        conversation.members.append(objectsIn: members.map { Member($0) })
        state.shouldIndicateActivity = true
        do {
            try userRealm.write {
                state.user?.conversations.append(conversation)
            }
        } catch {
            state.error = "Unable to open Realm write transaction"
            state.shouldIndicateActivity = false
            return
        }
        state.shouldIndicateActivity = false
        done()
    }
}

struct SaveConversationButton_Previews: PreviewProvider {
    static var previews: some View {
        return AppearancePreviews(
            SaveConversationButton(
                name: "Example Conversation",
                members: ["rod@contoso.com", "jane@contoso.com", "freddy@contoso.com"])
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
