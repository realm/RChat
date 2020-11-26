//
//  Chatsters.swift
//  RChat
//
//  Created by Andrew Morgan on 25/11/2020.
//

import RealmSwift

class Chatster: Object {
    @objc dynamic var _id = UUID().uuidString // This will match the _id of the associated User
    @objc dynamic var partition = "all-users=all-the-users"
    @objc dynamic var userName: String?
    @objc dynamic var displayName: String?
    @objc dynamic var avatarImage: Photo?
    @objc dynamic var lastSeenAt: Date?
    @objc dynamic var presence = "Off-Line"
    
    var presenceState: Presence {
        get { return Presence(rawValue: presence) ?? .hidden }
        set { presence = newValue.asString }
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}

extension Chatster: Identifiable {
    var id: String { _id }
}
