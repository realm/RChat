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
    
    @FetchRealmResults(Chatster.self) var chatsters
    
    @State private var name = ""
    @State private var members = [String]()
    @State private var candidateMember = ""
    @State private var candidateMembers = [String]()
    
    private var isEmpty: Bool {
        !(name != "" && members.count > 0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
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
                Spacer()
                if let error = state.error {
                    Text("Error: \(error)")
                        .foregroundColor(Color.red)
                }
            }
            .padding()
            .navigationBarTitle("New Chat", displayMode: .inline)
            .navigationBarItems(trailing:
                                    SaveConversationButton(name: name, members: members, presentationMode: presentationMode)
                                    .environment(
                                        \.realmConfiguration,
                                        app.currentUser!.configuration(partitionValue: "user=\(state.user?._id ?? "")"))
                                    .disabled(isEmpty)
                                    .padding()
            )
        }
        .onAppear(perform: searchUsers)
    }
    
    private func searchUsers() {
        var candidateChatsters: Results<Chatster>
        if candidateMember == "" {
            candidateChatsters = chatsters
        } else {
            let predicate = NSPredicate(format: "userName CONTAINS[cd] %@", candidateMember)
            candidateChatsters = chatsters.filter(predicate)
        }
        candidateMembers = []
        candidateChatsters.forEach { chatster in
            if !members.contains(chatster.userName) && chatster.userName != state.user?.userName {
                candidateMembers.append(chatster.userName)
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
}

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            NewConversationView()
                .environmentObject(AppState.sample)
        )
    }
}
