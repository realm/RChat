//
//  UserProfileButton.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct UserProfileButton: View {
    @EnvironmentObject var state: AppState

    let action: () -> Void

    var body: some View {
        Button("Profile", action: action)
        .disabled(state.shouldIndicateActivity)
    }
}

struct UserProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        return AppearancePreviews(
            UserProfileButton(action: { })
        )
        .padding()
        .previewLayout(.sizeThatFits)
        .environmentObject(AppState.sample)
    }
}
