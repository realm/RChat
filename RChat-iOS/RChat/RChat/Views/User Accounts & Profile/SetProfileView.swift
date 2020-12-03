//
//  SetProfileView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import UIKit
import SwiftUI
import RealmSwift

struct SetProfileView: View {
    @EnvironmentObject var state: AppState
    @AppStorage("shouldShareLocation") var shouldShareLocation = false
    @AppStorage("shouldSharePresence") var shouldSharePresence = false
    
    @Binding var isPresented: Bool

    @State var displayName = ""
    @State var photo: Photo?
    @State var photoAdded = false
    
    var body: some View {
        Form {
            Section(header: Text("User Profile")) {
                if let photo = photo {
                    AvatarButton(photo: photo) {
                        self.showPhotoTaker()
                    }
                }
                if photo == nil {
                    Button(action: { self.showPhotoTaker() }) {
                        Text("Add Photo")
                    }
                }
                InputField(title: "Display Name", text: $displayName)
                CallToActionButton(title: "Save User Profile", action: saveProfile)
            }
            Section(header: Text("Device Settings")) {
                Toggle(isOn: $shouldShareLocation, label: {
                    Text("Share Location")
                })
                .onChange(of: shouldShareLocation) { value in
                    if value {
                        _ = LocationHelper.currentLocation
                    }
                }
                Toggle(isOn: $shouldSharePresence, label: {
                    Text("Share Presence")
                })
                OnlineAlertSettings()
            }
        }
        .onAppear { initData() }
        .padding()
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: { isPresented.toggle() }) { BackButton() },
            trailing: state.loggedIn ? LogoutButton(action: { isPresented.toggle() }) : nil)
    }
    
    func initData() {
        displayName = state.user?.userPreferences?.displayName ?? ""
        photo = state.user?.userPreferences?.avatarImage
    }
    
    func saveProfile() {
        state.shouldIndicateActivity = true
        let realmConfig = app.currentUser?.configuration(partitionValue: state.user?.partition ?? "")
        guard var config = realmConfig else {
            state.error = "Cannot get Realm config from current user"
            return
        }
        config.objectTypes = [User.self, UserPreferences.self, Conversation.self, Photo.self, Member.self]
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
                        if photoAdded {
                            guard let newPhoto = photo else {
                                print("Missing photo")
                                return
                            }
                            state.user?.userPreferences?.avatarImage = newPhoto
                        }
                        state.user?.presenceState = shouldSharePresence ? .onLine : .hidden
                    }
                } catch {
                    state.error = "Unable to open Realm write transaction"
                }
                state.shouldIndicateActivity = false
            })
            .store(in: &self.state.cancellables)
    }
    
    private func showPhotoTaker() {
        PhotoCaptureController.show(source: .camera) { controller, photo in
            self.photo = photo
            photoAdded = true
            controller.hide()
        }
    }
}

struct SetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let previewState: AppState = .sample
        return AppearancePreviews(
            NavigationView {
                SetProfileView(isPresented: .constant(true))
            }
        )
        .environmentObject(previewState)
    }
}
