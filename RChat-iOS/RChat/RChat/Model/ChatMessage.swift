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
    @objc dynamic var author: String? // username
    @objc dynamic var text = ""
    @objc dynamic var image: Photo?
    @objc dynamic var timestamp = Date()

    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(conversationId: String, author: String, text: String, image: Photo?) {
        self.init()
        self.partition = "conversation=\(conversationId)"
        self.author = author
        self.text = text
        self.image = image ?? nil
    }
}

extension ChatMessage: Identifiable {
    var id: String { _id }
}
