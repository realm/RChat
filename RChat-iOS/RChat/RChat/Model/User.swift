//
//  User.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift

class User: Object {
    @objc dynamic var _id = UUID().uuidString
    @objc dynamic var partition = "" // "user=_id"
    @objc dynamic var username = ""
    @objc dynamic var userPreferences: UserPreferences?
    let location = List<Double>()
    @objc dynamic var lastSeenAt: Date?
    let conversations = List<Conversation>()

    override static func primaryKey() -> String? {
        return "_id"
    }
}

extension User: Identifiable {
    var id: String { _id }
}
