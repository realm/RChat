//
//  NewConversationView.swift
//  RChat
//
//  Created by Andrew Morgan on 27/11/2020.
//

import SwiftUI
import RealmSwift

struct NewConversationView: View {
    @EnvironmentObject var state: AppState
    
    @Binding var conversation: Conversation?
    let userRealm: Realm?
    
    @State var name = ""
    @State var members = [String]()
    @State var newMember = ""
    
    private var isEmpty: Bool {
        !(name != "" && members.count > 0)
    }
    
    var body: some View {
        VStack {
            InputField(title: "Chat Name", text: $name)
            HStack {
                InputField(title: "New Member", text: $newMember)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                if newMember == "" {
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gray)
                    }
                } else {
                    Button(action: { addMember(newMember: newMember) }) {
                        Image(systemName: "plus.circle.fill")
                        .renderingMode(.original)
                    }
                }
            }
            Divider()
            CaptionLabel(title: "Members")
            List {
                ForEach(members, id: \.self) { member in
                    Text(member)
                }
                .onDelete(perform: deleteMember)
            }
            Spacer()
        }
        .navigationBarTitle("New Chat", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: saveConversation) {
            Text("Save")
        }
        .disabled(isEmpty)
        )
        .padding()
    }
    
    func addMember(newMember: String) {
        state.error = nil
        if members.contains(newMember) {
            state.error = "\(newMember) is already part of this chat"
        } else {
            // TODO: Check if the user exists
            members.append(newMember)
            self.newMember = ""
        }
    }
    
    func deleteMember(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
    }
    
    func saveConversation() {
        state.error = nil
        let conversation = Conversation()
        conversation.displayName = name
        guard let userName = state.user?.userName else {
            state.error = "Current user is not set"
            return
        }
        guard let realm = userRealm else {
            state.error = "User Realm not set"
            return
        }
        conversation.members.append(Member(userName: userName, state: .active))
        members.forEach { username in
            conversation.members.append(Member(username))
        }
        state.shouldIndicateActivity = true
        do {
            try realm.write {
                state.user?.conversations.append(conversation)
            }
        } catch {
            state.error = "Unable to open Realm write transaction"
            state.shouldIndicateActivity = false
            return
        }
        state.shouldIndicateActivity = false
        self.conversation = conversation
    }
}

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppearancePreviews(
                NewConversationView(conversation: .constant(.sample), userRealm: .sample)
            )
        }
    }
}
