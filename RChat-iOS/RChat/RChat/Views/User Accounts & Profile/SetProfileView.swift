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
    @AppStorage("shouldSharePresence") var shouldSharePresence = true
    
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
            leading: Button(action: { isPresented = false }) { BackButton() },
            trailing: state.loggedIn ? LogoutButton(action: { isPresented = false }) : nil)
    }
    
    func initData() {
        displayName = state.user?.userPreferences?.displayName ?? ""
        photo = state.user?.userPreferences?.avatarImage
    }
    
    func saveProfile() {
        if let realm = state.userRealm {
            state.shouldIndicateActivity = true
            do {
                try realm.write {
                    state.user?.userPreferences?.displayName = displayName
                    if photoAdded {
                        guard let newPhoto = photo else {
                            print("Missing photo")
                            state.shouldIndicateActivity = false
                            return
                        }
                        state.user?.userPreferences?.avatarImage = newPhoto
                    }
                    state.user?.presenceState = shouldSharePresence ? .onLine : .hidden
                }
            } catch {
                state.error = "Unable to open Realm write transaction"
            }
        }
        state.shouldIndicateActivity = false
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
