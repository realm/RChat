//
//  Conversation.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import Foundation
import RealmSwift

class Conversation: EmbeddedObject, ObservableObject, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var displayName = ""
    @objc dynamic var unreadCount = 0
    var members = List<Member>()
}
