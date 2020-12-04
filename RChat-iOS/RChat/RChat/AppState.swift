//
//  AppState.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift
import SwiftUI
import Combine

class AppState: ObservableObject {
    @AppStorage("shouldSharePresence") var shouldSharePresence = false
    
    var loginPublisher = PassthroughSubject<RealmSwift.User, Error>()
    var logoutPublisher = PassthroughSubject<Void, Error>()
    let userRealmPublisher = PassthroughSubject<Realm, Error>()
    var cancellables = Set<AnyCancellable>()

    @Published var error: String?
    @Published var busyCount = 0

    var shouldIndicateActivity: Bool {
        get {
            return busyCount > 0
        }
        set (newState) {
            if newState {
                busyCount += 1
            } else {
                if busyCount > 0 {
                    busyCount -= 1
                } else {
                    print("Attempted to decrement busyCount below 1")
                }
            }
        }
    }
    
    var user: User?

    var loggedIn: Bool {
        app.currentUser != nil && app.currentUser?.state == .loggedIn
    }

    init() {
        _  = app.currentUser?.logOut()

        loginPublisher
            .receive(on: DispatchQueue.main)
            .flatMap { user -> RealmPublishers.AsyncOpenPublisher in
                self.shouldIndicateActivity = true
                var realmConfig = user.configuration(partitionValue: "user=\(user.id)")
                realmConfig.objectTypes = [User.self, UserPreferences.self, Conversation.self, Photo.self, Member.self]
                return Realm.asyncOpen(configuration: realmConfig)
            }
            .receive(on: DispatchQueue.main)
            .map {
                self.shouldIndicateActivity = false
                return $0
            }
            .subscribe(userRealmPublisher)
            .store(in: &self.cancellables)

        userRealmPublisher
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    self.error = "Failed to log in and open realm: \(error.localizedDescription)"
                }
            }, receiveValue: { realm in
//            print("Realm User file location: \(realm.configuration.fileURL!.path)")
            self.user = realm.objects(User.self).first
                do {
                    try realm.write {
                        self.user?.presenceState = self.shouldSharePresence ? .onLine : .hidden
                    }
                } catch {
                    self.error = "Unable to open Realm write transaction"
                }
            })
            .store(in: &cancellables)

        logoutPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
                self.user = nil
            })
            .store(in: &cancellables)
    }
}
