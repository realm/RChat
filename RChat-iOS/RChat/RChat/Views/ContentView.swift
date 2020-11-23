//
//  ContentView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("shouldShareLocation") var shouldShareLocation = false
    @AppStorage("shouldSharePresence") var shouldSharePresence = false
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if state.loggedIn {
                        if state.user != nil {
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
            .navigationBarItems(leading: state.loggedIn ? LogoutButton() : nil)
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
