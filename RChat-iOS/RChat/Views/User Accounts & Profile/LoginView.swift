//
//  LoginView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI
import RealmSwift

struct LoginView: View {

    @EnvironmentObject var state: AppState
    
    @State private var username = ""
    @State private var password = ""
    @State private var newUser = false

    private enum Dimensions {
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.padding) {
            Spacer()
            InputField(title: "Email/Username",
                       text: self.$username)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            InputField(title: "Password",
                       text: self.$password,
                       showingSecureField: true)
            CallToActionButton(
                title: newUser ? "Register User" : "Log In",
                action: { self.userAction(username: self.username, password: self.password) })
            HStack {
                CheckBox(title: "Register new user", isChecked: $newUser)
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, Dimensions.padding)
        .navigationBarTitle("Log In", displayMode: .inline)
        .navigationBarItems(trailing: EmptyView())
    }
    
    private func userAction(username: String, password: String) {
        state.shouldIndicateActivity = true
        if newUser {
            signup(username: username, password: password)
        } else {
            login(username: username, password: password)
        }
    }

    private func signup(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            state.shouldIndicateActivity = false
            return
        }
        self.state.error = nil
        app.emailPasswordAuth.registerUser(email: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                state.shouldIndicateActivity = false
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state.error = error.localizedDescription
                }
            }, receiveValue: {
                self.state.error = nil
                login(username: username, password: password)
            })
            .store(in: &state.cancellables)
    }

    private func login(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            state.shouldIndicateActivity = false
            return
        }
        self.state.error = nil
        app.login(credentials: .emailPassword(email: username, password: password))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                state.shouldIndicateActivity = false
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state.error = error.localizedDescription
                }
            }, receiveValue: {
                self.state.error = nil
                state.loginPublisher.send($0)
            })
            .store(in: &state.cancellables)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                LoginView()
                    .environmentObject(AppState())
                Landscape(
                    LoginView()
                        .environmentObject(AppState())
                )
            }
        )
    }
}
