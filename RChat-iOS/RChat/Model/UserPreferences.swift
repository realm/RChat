//
//  UserPreferences.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift

@objcMembers class UserPreferences: EmbeddedObject, ObjectKeyIdentifiable {
    dynamic var displayName: String?
    dynamic var avatarImage: Photo?

    var isEmpty: Bool { displayName == nil || displayName == "" }
}
