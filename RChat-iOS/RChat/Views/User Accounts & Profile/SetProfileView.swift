//
//  SetProfileView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import UIKit
import SwiftUI
import RealmSwift

struct SetProfileView: View {
    @ObservedResults(User.self) var users
    
    @Binding var isPresented: Bool
    
    // TODO: Check if still needed
    @State private var isWaiting = true
    
    var body: some View {
        ZStack {
            if let user = users.first {
                SetUserProfileView(user: user, isPresented: $isPresented)
            }
            if isWaiting {
                ProgressView()
                    .onAppear(perform: waitABit)
            }
        }
    }
    
    private func waitABit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isWaiting = false
        }
    }
}

struct SetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        return AppearancePreviews(
            NavigationView {
                SetProfileView(isPresented: .constant(true))
            }
        )
    }
}
