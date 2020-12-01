//
//  SampleData.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

// swiftlint:disable line_length
// swiftlint:disable force_try

import RealmSwift
import UIKit

protocol Samplable {
    associatedtype Item
    static var sample: Item { get }
    static var samples: [Item] { get }
}

extension Date {
    static var random: Date {
        Date(timeIntervalSince1970: (50 * 365 * 24 * 3600 + Double.random(in: 0..<(3600 * 24 * 365))))
    }
}

extension User {
    convenience init(username: String, userPreferences: UserPreferences, conversations: [Conversation]) {
        self.init()
        partition = "user=\(_id)"
        self.userName = username
        self.userPreferences = userPreferences
        self.location.append(-0.10689139236939127 + Double.random(in: -10..<10))
        self.location.append(51.506520923981554 + Double.random(in: -10..<10))
        self.lastSeenAt = Date.random
        conversations.forEach { conversation in
            self.conversations.append(conversation)
        }
    }
}

extension User: Samplable {
    static var samples: [User] { [sample, sample2, sample3] }
    static var sample: User {
        User(username: "rod@contoso.com", userPreferences: .sample, conversations: [.sample, .sample2, .sample3])
    }
    static var sample2: User {
        User(username: "jane@contoso.com", userPreferences: .sample2, conversations: [.sample, .sample2])
    }
    static var sample3: User {
        User(username: "freddy@contoso.com", userPreferences: .sample3, conversations: [.sample, .sample3])
    }
}

extension UserPreferences {
    convenience init(displayName: String, photo: Photo) {
        self.init()
        self.displayName = displayName
        self.avatarImage = photo
    }
}

extension UserPreferences: Samplable {
    static var samples: [UserPreferences] { [sample, sample2, sample3] }
    static var sample = UserPreferences(displayName: "Rod Burton", photo: .sample)
    static var sample2 = UserPreferences(displayName: "Jane Tucker", photo: .sample2)
    static var sample3 = UserPreferences(displayName: "Freddy Marks", photo: .sample3)
}

extension Conversation {
    convenience init(displayName: String, unreadCount: Int, members: [String]) {
        self.init()
        self.displayName = displayName
        self.unreadCount = unreadCount
        members.forEach { username in
            self.members.append(Member(username))
        }
    }
}

extension Conversation: Samplable {
    static var samples: [Conversation] { [sample, sample2, sample3] }
    static var sample: Conversation {
        Conversation(displayName: "Sample chat", unreadCount: 2, members: ["rod@contoso.com", "jane@contoso.com", "freddy@contoso.com"])
    }
    static var sample2: Conversation {
        Conversation(displayName: "Fishy chat", unreadCount: 0, members: ["rod@contoso.com", "jane@contoso.com"])
    }
    static var sample3: Conversation {
        Conversation(displayName: "Third chat", unreadCount: 1, members: ["rod@contoso.com", "freddy@contoso.com"])
    }
}

extension Chatster {
    convenience init(user: User) {
        self.init()
        self._id = user._id
        self.userName = user.userName
        self.displayName = user.userPreferences!.displayName
        self.avatarImage = Photo(photo: user.userPreferences!.avatarImage!)
        lastSeenAt = Date.random
        self.presence = user.presence
    }
}

extension Chatster: Samplable {
    static var samples: [Chatster] { [sample, sample2, sample3] }
    static var sample: Chatster { Chatster(user: .sample) }
    static var sample2: Chatster { Chatster(user: .sample2) }
    static var sample3: Chatster { Chatster(user: .sample3) }
}

extension AppState {
    convenience init(user: User) {
        self.init()
        self.user = user
    }
}

extension AppState: Samplable {
    static var samples: [AppState] { [sample, sample2, sample3] }
    static var sample: AppState { AppState(user: .sample) }
    static var sample2: AppState { AppState(user: .sample2) }
    static var sample3: AppState { AppState(user: .sample3) }
}

extension Photo {
    convenience init(photoName: String) {
        self.init()
        self.thumbNail = (UIImage(named: photoName) ?? UIImage()).jpegData(compressionQuality: 0.8)
        self.picture = (UIImage(named: photoName) ?? UIImage()).jpegData(compressionQuality: 0.8)
        self.date = Date.random
    }
    convenience init(photo: Photo) {
        self.init()
        self.thumbNail = photo.thumbNail
        self.picture = photo.picture
        self.date = photo.date
    }
}

extension Photo: Samplable {
    static var samples: [Photo] { [sample, sample2, sample3]}
    static var sample: Photo { Photo(photoName: "rod") }
    static var sample2: Photo { Photo(photoName: "jane") }
    static var sample3: Photo { Photo(photoName: "freddy") }
    static var spud: Photo { Photo(photoName: "spud\(Int.random(in: 1...8))") }
}

extension ChatMessage {
    convenience init(conversation: Conversation, author: User, text: String = "This is the text for the message", includePhoto: Bool = false, readers: [User]) {
        self.init()
        partition = "conversation=\(conversation.id)"
        self.author = author.userName
        self.text = text
        self.image = Photo.spud
        self.timestamp = Date.random
        readers.forEach { user in
            self.whoHasRead.append(user.userName)
        }
    }
}

extension ChatMessage: Samplable {
    static var samples: [ChatMessage] { [sample, sample2, sample3, sample20, sample22, sample23, sample30, sample32, sample33] }
    static var sample: ChatMessage { ChatMessage(conversation: .sample, author: .sample, readers: [.sample2]) }
    static var sample2: ChatMessage { ChatMessage(conversation: .sample, author: .sample2, readers: [.sample, .sample3]) }
    static var sample3: ChatMessage { ChatMessage(conversation: .sample, author: .sample3, text: "Thoughts on this spud?", includePhoto: true, readers: [.sample3])}
    static var sample20: ChatMessage { ChatMessage(conversation: .sample2, author: .sample, readers: [.sample2]) }
    static var sample22: ChatMessage { ChatMessage(conversation: .sample2, author: .sample2, readers: [.sample, .sample3]) }
    static var sample23: ChatMessage { ChatMessage(conversation: .sample2, author: .sample3, text: "Fancy trying this?", includePhoto: true, readers: [.sample3])}
    static var sample30: ChatMessage { ChatMessage(conversation: .sample3, author: .sample, readers: [.sample2]) }
    static var sample32: ChatMessage { ChatMessage(conversation: .sample3, author: .sample2, readers: [.sample, .sample3]) }
    static var sample33: ChatMessage { ChatMessage(conversation: .sample3, author: .sample3, text: "Is this a bit controversial? If nothing else, this is a very long, tedious post - I just hope that there's spaces for it all to fit in", includePhoto: true, readers: [.sample3])}
}

extension Realm: Samplable {
    static var samples: [Realm] { [sample] }
    static var sample: Realm {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            User.samples.forEach { user in
                realm.add(user)
            }
            Chatster.samples.forEach { chatster in
                realm.add(chatster)
            }
            ChatMessage.samples.forEach { message in
                realm.add(message)
            }
        }
        return realm
    }
}
