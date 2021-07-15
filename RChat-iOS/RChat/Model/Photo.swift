//
//  Photo.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import RealmSwift
import SwiftUI

class Photo: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var _id = UUID().uuidString
    @Persisted var thumbNail: Data?
    @Persisted var picture: Data?
    @Persisted var date = Date()
}
