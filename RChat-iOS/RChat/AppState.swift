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
    
    @Published var error: String?
    @Published var busyCount = 0
    
    var cancellables = Set<AnyCancellable>()

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

    var loggedIn: Bool {
        app.currentUser != nil && app.currentUser?.state == .loggedIn
    }

    init() {
        app.currentUser?.logOut { _ in
        }
    }
}
