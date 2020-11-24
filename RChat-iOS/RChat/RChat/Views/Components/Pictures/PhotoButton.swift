//
//  PhotoButton.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct PhotoButton: View {
    let photo: Photo
    let action: () -> Void
    var body: some View {
        ZStack {
            Button(action: action) {
                PhotoThumbNailView(photo: photo)
            }
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 40, height: 30)
                .foregroundColor(.gray)
                .opacity(0.9)
        }
    }
}

struct PhotoButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            PhotoButton(photo: .sample, action: {})
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
