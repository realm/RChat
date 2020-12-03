//
//  AddPhotoButton.swift
//  RChat
//
//  Created by Andrew Morgan on 02/12/2020.
//

import SwiftUI

// TODO: Delete if not used

struct AddPhotoButton: View {
    let action: () -> Void
    var photo: Photo?

    private enum Dimensions {
        static let maxSize: CGFloat = 150
        static let minSize: CGFloat = 50
        static let radius: CGFloat = 20
    }
    
    var body: some View {
        ZStack {
            Button(action: action) {
                    ThumbNailView(photo: photo)
            }
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 40, height: 30)
                .foregroundColor(.gray)
                .opacity(0.9)
        }
        .frame(minWidth: Dimensions.minSize,
               maxWidth: photo == nil ? Dimensions.maxSize / 2 : Dimensions.maxSize,
               minHeight: Dimensions.minSize,
               maxHeight: photo == nil ? Dimensions.maxSize / 2 : Dimensions.maxSize,
               alignment: .center)
    }
}

struct AddPhotoButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                AddPhotoButton(action: {})
                AddPhotoButton(action: {}, photo: .sample)
            }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
