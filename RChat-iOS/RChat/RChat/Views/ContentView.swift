//
//  ContentView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState

    @State var showingProfileView = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if state.loggedIn {
                        if (state.user != nil) && !state.user!.isProfileSet || showingProfileView {
                            SetProfileView(isPresented: $showingProfileView)
                        } else {
                            Text("Logged in")
                            .navigationBarTitle("RChat", displayMode: .inline)
                            .navigationBarItems(
                                leading: state.loggedIn ? LogoutButton() : nil,
                                trailing: state.loggedIn ? UserProfileButton { showingProfileView.toggle() } : nil
                            )
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
