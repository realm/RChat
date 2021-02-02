//
//  Chatsters.swift
//  RChat
//
//  Created by Andrew Morgan on 25/11/2020.
//

import Foundation
import RealmSwift

@objcMembers class Chatster: Object, ObjectKeyIdentifiable {
    dynamic var _id = UUID().uuidString // This will match the _id of the associated User
    dynamic var partition = "all-users=all-the-users"
    dynamic var userName = ""
    dynamic var displayName: String?
    dynamic var avatarImage: Photo?
    dynamic var lastSeenAt: Date?
    dynamic var presence = "Off-Line"
    
    var presenceState: Presence {
        get { return Presence(rawValue: presence) ?? .hidden }
        set { presence = newValue.asString }
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
