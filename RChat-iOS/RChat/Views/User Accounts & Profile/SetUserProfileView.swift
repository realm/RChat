//
//  SetUserProfileView.swift
//  RChat
//
//  Created by Andrew Morgan on 05/01/2022.
//

import SwiftUI
import RealmSwift

struct SetUserProfileView: View {
    @AppStorage("shouldShareLocation") var shouldShareLocation = false
    
    @ObservedRealmObject var user: User
    @Binding var isPresented: Bool
    @Binding var userID: String?
    
    @State private var displayName = ""
    @State private var photo: Photo?
    @State private var photoAdded = false
    
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
                OnlineAlertSettings()
            }
        }
        .onAppear(perform: initData)
        .navigationBarItems(
            leading: Button(action: { isPresented = false }) { BackButton() },
            trailing: LogoutButton(user: user, userID: $userID, action: { isPresented = false }))
        .padding()
        .navigationBarTitle("Edit Profile", displayMode: .inline)
    }
    
    private func initData() {
        displayName = user.userPreferences?.displayName ?? "Unknown"
        photo = user.userPreferences?.avatarImage
    }
    
    private func saveProfile() {
        let userPreferences = UserPreferences()
        userPreferences.displayName = displayName
        if photoAdded {
            guard let newPhoto = photo else {
                print("Missing photo")
                return
            }
            userPreferences.avatarImage = newPhoto
        } else {
            userPreferences.avatarImage = Photo(user.userPreferences?.avatarImage)
        }
        $user.userPreferences.wrappedValue = userPreferences
        $user.presenceState.wrappedValue = .onLine
        isPresented.toggle()
    }
    
    private func showPhotoTaker() {
        PhotoCaptureController.show(source: .camera) { controller, photo in
            self.photo = photo
            photoAdded = true
            controller.hide()
        }
    }
}

struct SetUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetUserProfileView(user: User(), isPresented: .constant(true), userID: .constant("Andrew"))
    }
}
