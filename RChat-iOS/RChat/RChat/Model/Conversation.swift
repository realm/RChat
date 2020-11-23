//
//  Conversation.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift

class Conversation: EmbeddedObject, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var _partition = "" // "conversation=_id"
    @objc dynamic var displayName = ""
    @objc dynamic var unreadCount = 0
    let members = LinkingObjects(fromType: User.self, property: "conversations")
}
