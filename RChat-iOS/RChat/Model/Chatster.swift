//
//  Chatsters.swift
//  RChat
//
//  Created by Andrew Morgan on 25/11/2020.
//

import Foundation
import RealmSwift

class Chatster: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id = UUID().uuidString // This will match the _id of the associated User
    @Persisted var partition = "all-users=all-the-users"
    @Persisted var userName = ""
    @Persisted var displayName: String?
    @Persisted var avatarImage: Photo?
    @Persisted var lastSeenAt: Date?
    @Persisted var presence = "Off-Line"
    
    var presenceState: Presence {
        get { return Presence(rawValue: presence) ?? .hidden }
        set { presence = newValue.asString }
    }
}
