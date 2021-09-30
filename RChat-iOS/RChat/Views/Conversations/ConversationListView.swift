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
    @State var showConversation = false
    @State var showingAddChat = false
    
    private let sortDescriptors = [
        SortDescriptor(keyPath: "unreadCount", ascending: false),
        SortDescriptor(keyPath: "displayName", ascending: true)
    ]
    
    var body: some View {
        VStack {
            if let conversations = users[0].conversations.sorted(by: sortDescriptors) {
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
        .sheet(isPresented: $showingAddChat) {
            NewConversationView()
                .environmentObject(state)
                .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "all-users=all-the-users"))
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
