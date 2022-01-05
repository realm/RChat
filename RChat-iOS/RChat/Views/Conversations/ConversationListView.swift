//
//  ConversationListView
//  RChat
//
//  Created by Andrew Morgan on 25/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationListView: View {
    @EnvironmentObject var state: AppState
    @ObservedResults(User.self) var users
    
    var isPreview = false
    
    @State private var conversation: Conversation?
    @State private var showConversation = false
    @State private var showingAddChat = false
    @State private var isWaiting = true
    
    private let sortDescriptors = [
        SortDescriptor(keyPath: "unreadCount", ascending: false),
        SortDescriptor(keyPath: "displayName", ascending: true)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                if let conversations = users.first?.conversations.sorted(by: sortDescriptors) {
                    List {
                        ForEach(conversations) { conversation in
                            Button(action: {
                                self.conversation = conversation
                                showConversation.toggle()
                            }) { ConversationCardView(conversation: conversation, isPreview: isPreview) }
                        }
                    }
                    Button(action: { showingAddChat.toggle() }) {
                        Text("New Chat Room")
                    }
                    .disabled(showingAddChat)
                }
                Spacer()
                if isPreview {
                    NavigationLink(
                        destination: ChatRoomView(conversation: conversation),
                        isActive: $showConversation) { EmptyView() }
                } else {
                    if let user = state.user {
                        NavigationLink(
                            destination: ChatRoomView(conversation: conversation)
                                .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "user=\(user._id)")),
                            isActive: $showConversation) { EmptyView() }
                    }
                }
            }
            if isWaiting {
                ProgressView()
                    .onAppear(perform: waitABit)
            }
        }
        .sheet(isPresented: $showingAddChat) {
            NewConversationView()
                .environmentObject(state)
                .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "all-users=all-the-users"))
        }
    }
    
    private func waitABit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isWaiting = false
        }
    }
}

struct ConversationListViewPreviews: PreviewProvider {
    
    static var previews: some View {
        Realm.bootstrap()
        
        return ConversationListView(isPreview: true)
            .environmentObject(AppState.sample)
    }
}
