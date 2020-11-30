//
//  NewConversationView.swift
//  RChat
//
//  Created by Andrew Morgan on 27/11/2020.
//

import SwiftUI

struct NewConversationView: View {
    @Binding var conversationId: String?
    
    var body: some View {
        Text("New Conversation")
        .navigationBarTitle("New Chat", displayMode: .inline)
    }
}

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewConversationView(conversationId: .constant(nil))
        }
    }
}
