//
//  AvatarButton.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct AvatarButton: View {
    let photo: Photo
    let action: () -> Void
    var body: some View {
        ZStack {
            Button(action: action) {
                AvatarThumbNailView(photo: photo)
            }
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 40, height: 30)
                .foregroundColor(.gray)
                .opacity(0.9)
        }
    }
}

struct AvatarButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            AvatarButton(photo: .sample, action: {})
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
