//
//  SetProfileView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI
import RealmSwift

struct SetProfileView: View {
    @EnvironmentObject var state: AppState
    var action: () -> Void = {}
    @State var displayName = ""

    var body: some View {
        VStack {
            Spacer()
            InputField(title: "Display Name", text: $displayName)
            CallToActionButton(title: "Save", action: saveProfile)
            Spacer()
        }
            .onAppear { initData() }
        .padding()
    }

    func initData() {
        displayName = state.user?.userPreferences?.displayName ?? ""
    }

    func saveProfile() {
        state.shouldIndicateActivity = true
        let realmConfig = app.currentUser?.configuration(partitionValue: state.user?.partition ?? "")
        guard var config = realmConfig else {
            state.error = "Cannot get Realm config from current user"
            return
        }
        config.objectTypes = [User.self, UserPreferences.self, Conversation.self]
        Realm.asyncOpen(configuration: config)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                state.shouldIndicateActivity = false
                if case let .failure(error) = result {
                    self.state.error = "Failed to open realm: \(error.localizedDescription)"
                }
            }, receiveValue: { realm in
                print("Realm User file location: \(realm.configuration.fileURL!.path)")
                do {
                    try realm.write {
                        state.user?.userPreferences?.displayName = displayName
                    }
                    action()
                } catch {
                    state.error = "Unable to open Realm write transaction"
                }
                state.shouldIndicateActivity = false
            })
            .store(in: &self.state.cancellables)
    }
}

struct SetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let previewState: AppState = .sample
        return AppearancePreviews(
            SetProfileView()
        )
        .environmentObject(previewState)
    }
}
