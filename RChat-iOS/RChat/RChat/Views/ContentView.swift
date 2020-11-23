//
//  ContentView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct ContentView: View {
    // TODO: Move these to where they're used
    @AppStorage("shouldShareLocation") var shouldShareLocation = false
    @AppStorage("shouldSharePresence") var shouldSharePresence = false

    @EnvironmentObject var state: AppState

    @State var showingProfileSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if state.loggedIn {
                        if (state.user != nil) && !state.user!.isProfileSet {
                            NewProfileView()
                        } else {
                            Text("Logged in")
                        }
                    } else {
                        LoginView()
                    }
                    Spacer()
                    if let error = state.error {
                        Text("Error: \(error)")
                            .foregroundColor(Color.red)
                    }
                }
                if state.shouldIndicateActivity {
                    OpaqueProgressView("Working With Realm")
                }
            }
            .navigationBarItems(
                leading: state.loggedIn ? LogoutButton() : nil,
                trailing: state.loggedIn ? UserProfileButton { showingProfileSheet.toggle() } : nil
            )
            .sheet(isPresented: $showingProfileSheet) { ProfileSheet() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ContentView()
                    .environmentObject(AppState())
                Landscape(ContentView()
                            .environmentObject(AppState()))
            }
        )
    }
}
