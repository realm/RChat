//
//  SampleData.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import Foundation

protocol Samplable {
    associatedtype Item
    static var sample: Item { get }
}

extension User: Samplable {
    static var sample: User {
        let user = User()
        user.partition = "dummy-partition"
        user.username = "fred@flinstone.com"
        user.userPreferences = .sample
        user.location.append(-0.10689139236939127)
        user.location.append(51.506520923981554)
        user.lastSeenAt = Date()
        user.conversations.append(.sample)
        return user
    }
}

extension UserPreferences: Samplable {
    static var sample: UserPreferences {
        let userPref = UserPreferences()
        userPref.displayName = "Fred Flinstone"
        return userPref
    }
}

extension Conversation: Samplable {
    static var sample: Conversation {
        let conv = Conversation()
        conv.displayName = "Sample Chat"
        conv.unreadCount = 3
        return conv
    }
}

extension AppState: Samplable {
    static var sample: AppState {
        let state = AppState()
        state.user = .sample
        return state
    }
}
