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
    @ObservedRealmObject var user: User
    
    var isPreview = false
    
    @State private var conversation: Conversation?
    @State private var showingAddChat = false
    
    private let sortDescriptors = [
        SortDescriptor(keyPath: "unreadCount", ascending: false),
        SortDescriptor(keyPath: "displayName", ascending: true)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                let conversations = user.conversations.sorted(by: sortDescriptors)
                List(conversations) { conversation in
                    NavigationLink {
                        ChatRoomView(user: user, conversation: conversation)
                    } label: {
                        ConversationCardView(conversation: conversation, isPreview: isPreview)
                            .listRowSeparator(.hidden)
                    }
                }
                Button(action: { showingAddChat.toggle() }) {
                    Text("New Chat Room")
                }
                .disabled(showingAddChat)
                Spacer()
            }
        }
        .onAppear {
            $user.presenceState.wrappedValue = .onLine
        }
        .sheet(isPresented: $showingAddChat) {
            NewConversationView(user: user)
                .environmentObject(state)
                .environment(\.realmConfiguration, app.currentUser!.flexibleSyncConfiguration())
        }
    }
}

struct ConversationListViewPreviews: PreviewProvider {

    static var previews: some View {
        Realm.bootstrap()

        return ConversationListView(user: .sample, isPreview: true)
            .environmentObject(AppState.sample)
    }
}
