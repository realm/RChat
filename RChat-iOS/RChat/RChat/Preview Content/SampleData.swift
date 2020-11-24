//
//  SampleData.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import Foundation
import UIKit

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

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension Photo: Samplable {
    static var sample: Photo {
        let photo = Photo()
        photo.picture = UIColor.orange.image(CGSize(width: 256, height: 256)).jpegData(compressionQuality: 0.8)
        photo.picture = UIColor.yellow.image(CGSize(width: 64, height: 64)).jpegData(compressionQuality: 0.8)
        return photo
    }
}
