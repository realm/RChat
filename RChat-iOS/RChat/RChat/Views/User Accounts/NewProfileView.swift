//
//  NewProfileView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct NewProfileView: View {
    var body: some View {
        SetProfileView()
        .navigationBarTitle("Create Profile", displayMode: .inline)
    }
}

struct NewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                NavigationView {
                    NewProfileView()
                }
                Landscape(
                    NavigationView {
                        NewProfileView()
                    }
                )
            }
            .environmentObject(AppState.sample)
        )
    }
}
