//
//  SignupView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI
import RealmSwift

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var state: AppState
    // TODO: Remove the username/password examples
    @State private var username = "rod@contoso.com"
    @State private var password = "billyfish"

    private enum Dimensions {
        static let topInputFieldPadding: CGFloat = 32.0
        static let buttonPadding: CGFloat = 24.0
        static let topPadding: CGFloat = 48.0
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        ZStack {
            VStack(spacing: Dimensions.padding) {
                Spacer()
                InputField(title: "Email/Username",
                           text: self.$username)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                InputField(title: "Password",
                           text: self.$password,
                           showingSecureField: true)
                CallToActionButton(
                    title: "Sign Up",
                    action: { self.signup(username: self.username, password: self.password) })
                Spacer()
                Spacer()
                if let error = state.error {
                    Text("Error: \(error)")
                        .foregroundColor(Color.red)
                }
            }
            if state.shouldIndicateActivity {
                OpaqueProgressView("Signing Up User")
            }
        }
        .padding(.horizontal, Dimensions.padding)
        .onAppear { state.error = nil }
    }

    private func signup(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            return
        }
        self.state.error = nil
        state.shouldIndicateActivity = true
        app.emailPasswordAuth.registerUser(email: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                // ZXZX TODO: See if this needs adding back in
                // Allow time for the backend trigger to run before letting the new
                // user log in
//                let secondsToDelay = 5.0
//                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
//                    state.shouldIndicateActivity = false
//                }
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state.error = error.localizedDescription
                }
            }, receiveValue: {
                self.state.error = nil
                // ZXZX TODO: Remove if add the timeout back in
                state.shouldIndicateActivity = false
                self.presentationMode.wrappedValue.dismiss()
            })
            .store(in: &state.cancellables)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                SignupView()
                    .environmentObject(AppState())
                Landscape(
                    SignupView()
                        .environmentObject(AppState())
                )
            }
        )
    }
}
