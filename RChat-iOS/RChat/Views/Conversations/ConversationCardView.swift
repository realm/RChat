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

    let conversation: Conversation
    
    @State private var shouldIndicateActivity = false
    
    var body: some View {
        ZStack {
            VStack {
                ConversationCardContentsView(conversation: conversation)
                    .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "all-users=all-the-users"))
            }
            if shouldIndicateActivity {
                OpaqueProgressView("Fetching Conversation")
            }
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
