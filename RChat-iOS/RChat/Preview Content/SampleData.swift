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
    convenience init(username: String, presence: Presence, userPreferences: UserPreferences, conversations: [Conversation]) {
        self.init()
        partition = "user=\(_id)"
        self.userName = username
        self.presence = presence.asString
        self.userPreferences = userPreferences
        self.lastSeenAt = Date.random
        conversations.forEach { conversation in
            self.conversations.append(conversation)
        }
    }
    
    convenience init(_ user: User) {
        self.init()
        partition = user.partition
        userName = user.userName
        userPreferences = UserPreferences(user.userPreferences)
        lastSeenAt = user.lastSeenAt
        conversations.append(objectsIn: user.conversations.map { Conversation($0) })
        presence = user.presence
    }
}

extension User: Samplable {
    static var samples: [User] { [sample, sample2, sample3] }
    static var sample: User {
        User(username: "rod@contoso.com", presence: .onLine, userPreferences: .sample, conversations: [.sample, .sample2, .sample3])
    }
    static var sample2: User {
        User(username: "jane@contoso.com", presence: .offLine, userPreferences: .sample2, conversations: [.sample, .sample2])
    }
    static var sample3: User {
        User(username: "freddy@contoso.com", presence: .hidden, userPreferences: .sample3, conversations: [.sample, .sample3])
    }
}

extension UserPreferences {
    convenience init(displayName: String, photo: Photo) {
        self.init()
        self.displayName = displayName
        self.avatarImage = photo
    }
    
    convenience init(_ userPreferences: UserPreferences?) {
        self.init()
        if let userPreferences = userPreferences {
            displayName = userPreferences.displayName
            avatarImage = Photo(userPreferences.avatarImage)
        }
    }
}

extension UserPreferences: Samplable {
    static var samples: [UserPreferences] { [sample, sample2, sample3] }
    static var sample = UserPreferences(displayName: "Rod Burton", photo: .sample)
    static var sample2 = UserPreferences(displayName: "Jane Tucker", photo: .sample2)
    static var sample3 = UserPreferences(displayName: "Freddy Marks", photo: .sample3)
}

extension Conversation {
    convenience init(displayName: String, unreadCount: Int, members: [Member]) {
        self.init()
        self.displayName = displayName
        self.unreadCount = unreadCount
        self.members.append(objectsIn: members.map { Member($0) })
        
//        forEach { username in
//            self.members.append(Member(username))
//        }
    }
    
    convenience init(_ conversation: Conversation) {
        self.init()
        displayName = conversation.displayName
        unreadCount = conversation.unreadCount
        members.append(objectsIn: conversation.members.map { Member($0) })
    }
}

extension Conversation: Samplable {
    static var samples: [Conversation] { [sample, sample2, sample3] }
    static var sample: Conversation {
        Conversation(displayName: "Sample chat", unreadCount: 2, members: Member.samples)
    }
    static var sample2: Conversation {
        Conversation(displayName: "Fishy chat", unreadCount: 0, members: Member.samples)
    }
    static var sample3: Conversation {
        Conversation(displayName: "Third chat", unreadCount: 1, members: Member.samples)
    }
}

extension Member {
    convenience init(_ member: Member) {
        self.init()
        userName = member.userName
        membershipStatus = member.membershipStatus
    }
}

extension Member: Samplable {
    static var samples: [Member] { [sample, sample2, sample3] }
    static var sample: Member {
        Member(userName: "rod@contoso.com", state: .active)
    }
    static var sample2: Member {
        Member(userName: "jane@contoso.com", state: .active)
    }
    static var sample3: Member {
        Member(userName: "freddy@contoso.com", state: .pending)
    }
}

extension Chatster {
    convenience init(user: User) {
        self.init()
        self._id = user._id
        self.userName = user.userName
        self.displayName = user.userPreferences!.displayName
        self.avatarImage = Photo(user.userPreferences?.avatarImage)
        lastSeenAt = Date.random
        self.presence = user.presence
    }
    
    convenience init(_ chatster: Chatster) {
        self.init()
        partition = chatster.partition
        userName = chatster.userName
        displayName = chatster.displayName
        avatarImage = Photo(chatster.avatarImage)
        lastSeenAt = chatster.lastSeenAt
        presence = chatster.presence
    }
}

extension Chatster: Samplable {
    static var samples: [Chatster] { [sample, sample2, sample3] }
    static var sample: Chatster { Chatster(user: User(.sample)) }
    static var sample2: Chatster { Chatster(user: User(.sample2)) }
    static var sample3: Chatster { Chatster(user: User(.sample3)) }
}

extension AppState: Samplable {
    static var samples: [AppState] { [sample, sample2, sample3] }
    static var sample: AppState { AppState() }
    static var sample2: AppState { AppState() }
    static var sample3: AppState { AppState() }
}

extension Photo {
    convenience init(photoName: String) {
        self.init()
        self.thumbNail = (UIImage(named: photoName) ?? UIImage()).jpegData(compressionQuality: 0.8)
        self.picture = (UIImage(named: photoName) ?? UIImage()).jpegData(compressionQuality: 0.8)
        self.date = Date.random
    }
    convenience init(_ photo: Photo?) {
        self.init()
        if let photo = photo {
            self.thumbNail = photo.thumbNail
            self.picture = photo.picture
            self.date = photo.date
        }
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
    convenience init(conversation: Conversation,
                     author: User,
                     text: String = "This is the text for the message",
                     includePhoto: Bool = false,
                     includeLocation: Bool = false) {
        self.init()
        partition = "conversation=\(conversation.id)"
        self.author = author.userName
        self.text = text
        if includePhoto { self.image = Photo.spud }
        self.timestamp = Date.random
        if includeLocation {
            self.location.append(-0.10689139236939127 + Double.random(in: -10..<10))
            self.location.append(51.506520923981554 + Double.random(in: -10..<10))
        }
    }
    
    convenience init(_ chatMessage: ChatMessage) {
        self.init()
        partition = chatMessage.partition
        author = chatMessage.author
        text = chatMessage.text
        image = Photo(chatMessage.image)
        location.append(objectsIn: chatMessage.location)
        timestamp = chatMessage.timestamp
    }
}

extension ChatMessage: Samplable {
    static var samples: [ChatMessage] { [sample, sample2, sample3, sample20, sample22, sample23, sample30, sample32, sample33] }
    static var sample: ChatMessage { ChatMessage(conversation: .sample, author: .sample) }
    static var sample2: ChatMessage { ChatMessage(conversation: .sample, author: .sample2, includePhoto: true) }
    static var sample3: ChatMessage { ChatMessage(conversation: .sample, author: .sample3, text: "Thoughts on this **spud**?", includePhoto: true, includeLocation: true)}
    static var sample20: ChatMessage { ChatMessage(conversation: .sample2, author: .sample) }
    static var sample22: ChatMessage { ChatMessage(conversation: .sample2, author: .sample2, includePhoto: true) }
    static var sample23: ChatMessage { ChatMessage(conversation: .sample2, author: .sample3, text: "Fancy trying this?", includePhoto: true, includeLocation: true)}
    static var sample30: ChatMessage { ChatMessage(conversation: .sample3, author: .sample) }
    static var sample32: ChatMessage { ChatMessage(conversation: .sample3, author: .sample2, includePhoto: true) }
    static var sample33: ChatMessage { ChatMessage(conversation: .sample3, author: .sample3, text: "Is this a bit controversial? If nothing else, this is a very long, tedious post - I just hope that there's space for it all to fit in", includePhoto: true, includeLocation: true)}
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
    
    static func bootstrap() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
                realm.add(Chatster.samples)
                realm.add(User(User.sample))
                realm.add(ChatMessage.samples)
            }
        } catch {
            print("Failed to bootstrap the default realm")
        }
    }
}
