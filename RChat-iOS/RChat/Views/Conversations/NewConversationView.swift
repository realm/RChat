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
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var members = [String]()
    @State private var candidateMember = ""
    @State private var candidateMembers = [String]()
    
    private var isEmpty: Bool {
        !(name != "" && members.count > 0)
    }
    
    var body: some View {
        VStack {
            InputField(title: "Chat Name", text: $name)
            CaptionLabel(title: "Add Members")
            SearchBox(searchText: $candidateMember, onCommit: searchUsers)
            List {
                ForEach(candidateMembers, id: \.self) { candidateMember in
                    Button(action: { addMember(candidateMember) }) {
                        HStack {
                            Text(candidateMember)
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                            .renderingMode(.original)
                        }
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
        .onAppear(perform: searchUsers)
    }
    
    private func searchUsers() {
        var candidateChatsters: Results<Chatster>
        if let chatsterRealm = state.chatsterRealm {
            let allChatsters = chatsterRealm.objects(Chatster.self)
            if candidateMember == "" {
                candidateChatsters = allChatsters
            } else {
                let predicate = NSPredicate(format: "userName CONTAINS[cd] %@", candidateMember)
                candidateChatsters = allChatsters.filter(predicate)
            }
            candidateMembers = []
            candidateChatsters.forEach { chatster in
                if let userName = chatster.userName {
                    if !members.contains(userName) && userName != state.user?.userName {
                        candidateMembers.append(userName)
                    }
                }
            }
        }
    }
    
    private func addMember(_ newMember: String) {
        state.error = nil
        if members.contains(newMember) {
            state.error = "\(newMember) is already part of this chat"
        } else {
            members.append(newMember)
            candidateMember = ""
            searchUsers()
        }
    }
    
    private func deleteMember(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
    }
    
    private func saveConversation() {
        state.error = nil
        let conversation = Conversation()
        conversation.displayName = name
        guard let userName = state.user?.userName else {
            state.error = "Current user is not set"
            return
        }
        guard let realm = state.userRealm else {
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
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppearancePreviews(
                NewConversationView()
                    .environmentObject(AppState.sample)
            )
        }
    }
}
