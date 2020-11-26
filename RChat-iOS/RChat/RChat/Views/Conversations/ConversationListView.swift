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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ConversationListViewPreviews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            ConversationListView()
        )
        .environmentObject(AppState.sample)
    }
}
