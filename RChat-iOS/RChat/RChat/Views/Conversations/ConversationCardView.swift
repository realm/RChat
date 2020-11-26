//
//  ConversationCardView.swift
//  RChat
//
//  Created by Andrew Morgan on 26/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationCardView: View {
    @EnvironmentObject var state: AppState
    
    @ObservedObject var conversation: Conversation
    
    @State var chatsters = [Chatster]()
    @State var shouldIndicateActivity = false
    
    private struct Dimensions {
        static let leadingSpacing: CGFloat = 4.0
        static let padding: CGFloat = 16.0
        static let heightDivider: CGFloat = 1.0
        static let circleSize: CGFloat = 12.0
        static let topPadding: CGFloat = 18.0
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top, spacing: .zero) {
                    
                }
                Divider()
                .frame(height: Dimensions.heightDivider)
            }
            if shouldIndicateActivity {
                OpaqueProgressView("Fetching Conversation")
            }
        }
        .onAppear { initData() }
    }
    
    func initData() {
        if let user = app.currentUser {
            shouldIndicateActivity = true
            var realmConfig = user.configuration(partitionValue: "all-users=all-the-users")
            realmConfig.objectTypes = [Chatster.self]
            Realm.asyncOpen(configuration: realmConfig)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    self.state.error = "Failed to open Chatster realm: \(error.localizedDescription)"
                    shouldIndicateActivity = false
                }
            }, receiveValue: { realm in
                print("Realm Chatster file location: \(realm.configuration.fileURL!.path)")
                let allChatsters = realm.objects(Chatster.self)
                for username in conversation.members {
                    chatsters.append(contentsOf: allChatsters.filter("username = %@", username))
                }
                shouldIndicateActivity = false
            })
            .store(in: &self.state.cancellables)
        }
    }
}

struct ConversationCardView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            ConversationCardView(conversation: .sample)
            .environmentObject(AppState.sample)
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
