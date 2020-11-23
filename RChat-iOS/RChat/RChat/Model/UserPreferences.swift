//
//  UserPreferences.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift

class UserPreferences: EmbeddedObject {
    @objc dynamic var displayName = ""
    @objc dynamic var avatarImage: Data?
}
