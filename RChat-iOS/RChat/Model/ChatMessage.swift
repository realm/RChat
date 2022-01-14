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
    @Persisted var conversationID = ""
    @Persisted var author: String? // username
    @Persisted var authorID: String
    @Persisted var text = ""
    @Persisted var image: Photo?
    @Persisted var location = List<Double>()
    @Persisted var timestamp = Date()

    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(author: String, authorID: String, text: String, image: Photo?, location: [Double] = []) {
        self.init()
        self.author = author
        self.authorID = authorID
        self.text = text
        self.image = image ?? nil
        location.forEach { coord in
            self.location.append(coord)
        }
    }
}
