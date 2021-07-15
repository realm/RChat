//
//  ChatMessage.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import Foundation
import RealmSwift

class ChatMessage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id = UUID().uuidString
    @Persisted var partition = "" // "conversation=<conversation-id>"
    @Persisted var author: String? // username
    @Persisted var text = ""
    @Persisted var image: Photo?
    @Persisted var location = List<Double>()
    @Persisted var timestamp = Date()

    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(author: String, text: String, image: Photo?, location: [Double] = []) {
        self.init()
        self.author = author
        self.text = text
        self.image = image ?? nil
        location.forEach { coord in
            self.location.append(coord)
        }
    }
    
    var conversationId: String {
        get { partition.components(separatedBy: "=")[1] }
        set(conversationId) { partition = "conversation=\(conversationId)"}
    }
}

extension ChatMessage: Identifiable {
    var id: String { _id }
}
