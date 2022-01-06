//
//  Conversation.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import Foundation
import RealmSwift

class Conversation: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id = UUID().uuidString
    @Persisted var displayName = ""
    @Persisted var unreadCount = 0
    @Persisted var members = List<Member>()
    
    convenience init(displayName: String, unreadCount: Int, members: List<Member>) {
        self.init()
        self.displayName = displayName
        self.unreadCount = unreadCount
        self.members = List<Member>()
        members.forEach { member in
            self.members.append(member.copy)
        }
    }
    
    var copy: Conversation {
        let members = List<Member>()
        self.members.forEach { member in
            members.append(member.copy)
        }
        return Conversation(displayName: displayName, unreadCount: unreadCount, members: members)
    }
}
