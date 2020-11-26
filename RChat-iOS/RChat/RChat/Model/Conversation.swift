//
//  Conversation.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift

class Conversation: EmbeddedObject, ObservableObject, Identifiable {
    @objc dynamic var id = UUID().uuidString // TODO: This should be a global ID the same for each user's copies
    @objc dynamic var displayName = ""
    @objc dynamic var unreadCount = 0
    
    // TODO: Replace with an array of Strings (usernames)
    let members = List<String>() // User.username
}
