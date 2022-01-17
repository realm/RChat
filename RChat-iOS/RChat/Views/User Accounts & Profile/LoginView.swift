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
    
    @Binding var userID: String?
    
    enum Field: Hashable {
        case username
        case password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var newUser = false
    
    @FocusState private var focussedField: Field?
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                TextField("username", text: $email)
                    .focused($focussedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit { focussedField = .password }
                SecureField("password", text: $password)
                    .focused($focussedField, equals: .password)
                    .onSubmit(userAction)
                    .submitLabel(.go)
                Button(action: { newUser.toggle() }) {
                    HStack {
                        Image(systemName: newUser ? "checkmark.square" : "square")
                        Text("Register new user")
                        Spacer()
                    }
                }
                Button(action: userAction) {
                    Text(newUser ? "Register new user" : "Log in")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focussedField = .username
            }
        }
        .padding()
    }
    
    func userAction() {
        state.error = nil
        state.shouldIndicateActivity = true
        Task {
            if newUser {
                do {
                    try await app.emailPasswordAuth.registerUser(email: email, password: password)
                } catch {
                    DispatchQueue.main.async {
                        state.error = error.localizedDescription
                        state.shouldIndicateActivity = false
                    }
                    return
                }
            }
            do {
                let user = try await app.login(credentials: .emailPassword(email: email, password: password))
                userID = user.id
                state.shouldIndicateActivity = false
            } catch {
                DispatchQueue.main.async {
                    state.error = error.localizedDescription
                    state.shouldIndicateActivity = false
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewColorScheme(PreviewOrientation(
            LoginView(userID: .constant("1234554321"))
                .environmentObject(AppState())
        ))
    }
}
