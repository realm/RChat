//
//  UserPreferences.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift

class UserPreferences: EmbeddedObject {
    @objc dynamic var displayName: String?
    @objc dynamic var avatarImage: Photo?

    var isEmpty: Bool { displayName == nil }
}
