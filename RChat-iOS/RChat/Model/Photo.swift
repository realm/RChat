//
//  Photo.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import RealmSwift
import SwiftUI

@objcMembers class Photo: EmbeddedObject, ObjectKeyIdentifiable {
    dynamic var _id = UUID().uuidString
    dynamic var thumbNail: Data?
    dynamic var picture: Data?
    dynamic var date = Date()
}
