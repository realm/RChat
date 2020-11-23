//
//  ProfileSheet.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct ProfileSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationView {
            VStack {
                SetProfileView { self.presentationMode.wrappedValue.dismiss() }
                if let error = state.error {
                    Text("Error: \(error)")
                        .foregroundColor(Color.red)
                }
        }
            .navigationBarTitle("Update Profile", displayMode: .inline)
        }
    }
}

struct ProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            ProfileSheet()
        )
        .environmentObject(AppState.sample)
    }
}
