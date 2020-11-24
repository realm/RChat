//
//  ChatMessage.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift

class ChatMessage: Object {
    @objc dynamic var _id = UUID().uuidString
    @objc dynamic var partition = "" // "conversation=<conversation-id>"
    @objc dynamic var conversation = ""
    @objc dynamic var user: User?
    @objc dynamic var image: Photo?
    @objc dynamic var timestamp = Date()

    override static func primaryKey() -> String? {
        return "_id"
    }
}

extension ChatMessage: Identifiable {
    var id: String { _id }
}
