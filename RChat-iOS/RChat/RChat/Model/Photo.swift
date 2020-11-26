//
//  Photo.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import RealmSwift
import SwiftUI

class Photo: EmbeddedObject, ObservableObject {
    @objc dynamic var _id = UUID().uuidString
    @objc dynamic var thumbNail: Data?
    @objc dynamic var picture: Data?
    @objc dynamic var date = Date()
}

extension Photo: Identifiable {
    var id: String { _id }
}
