//
//  ActiveConversationView.swift
//  RChat
//
//  Created by Andrew Morgan on 02/12/2020.
//

// TODO: Remove if not used

import SwiftUI
import RealmSwift

struct ActiveConversationView: View {
    @EnvironmentObject var state: AppState
    
    @Binding var conversation: Conversation?
    var userRealm: Realm?
//    var userRealm: Realm? = .sample
    
    @State var name = ""
    @State var members = [String]()
    @State var newMember = ""
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    func initData() {
//        if let user = app.currentUser {
//            state.shouldIndicateActivity = true
//            var realmConfig = user.configuration(partitionValue: "all-users=all-the-users")
//            realmConfig.objectTypes = [Chatster.self, Photo.self]
//            Realm.asyncOpen(configuration: realmConfig)
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: { result in
//                    if case let .failure(error) = result {
//                        self.state.error = "Failed to open Chatster realm: \(error.localizedDescription)"
//                        state.shouldIndicateActivity = false
//                    }
//                }, receiveValue: { realm in
//                    print("Realm Chatster file location: \(realm.configuration.fileURL!.path)")
//                    chatsterRealm = realm
//                    realmChatsterNotificationToken = realm.observe {_, _ in
//                        lastSync = Date()
//                    }
//                    watchUserRealm(user: user)
//                })
//                .store(in: &self.state.cancellables)
//        }
    }
}

struct ActiveConversationView_Previews: PreviewProvider {
    var realm = Realm.sample
    
    static var previews: some View {
        ActiveConversationView(conversation: .constant(.sample))
//        ActiveConversationView(conversation: .constant(.sample), userRealm: .sample)
            .environmentObject(AppState.sample)
    }
}
