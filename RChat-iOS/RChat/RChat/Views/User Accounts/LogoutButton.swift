//
//  LogoutButton.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        Button("Log Out") {
            state.shouldIndicateActivity = true
            app.currentUser?.logOut()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: {
                    state.shouldIndicateActivity = false
                    state.logoutPublisher.send($0)
                })
                .store(in: &state.cancellables)
        }
        .disabled(state.shouldIndicateActivity)
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            LogoutButton()
                .environmentObject(AppState())
                .previewLayout(.sizeThatFits)
                .padding()
        )
    }
}
