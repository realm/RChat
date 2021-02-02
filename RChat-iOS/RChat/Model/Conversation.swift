//
//  Conversation.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import Foundation
import RealmSwift

@objcMembers class Conversation: EmbeddedObject, ObjectKeyIdentifiable {
    dynamic var id = UUID().uuidString
    dynamic var displayName = ""
    dynamic var unreadCount = 0
    var members = List<Member>()
}
