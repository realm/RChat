//
//  PhotoThumbNailView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct PhotoThumbNailView: View {
    let photo: Photo
    let imageSize: CGFloat = 102

    private enum Dimensions {
        static let radius: CGFloat = 4
        static let iconPadding: CGFloat = 8
    }

    var body: some View {
        VStack {
            if photo.thumbNail != nil || photo.picture != nil {
                if let photo = photo.thumbNail {
                    Thumbnail(imageData: photo)
                } else {
                    if let photo = photo.picture {
                        Thumbnail(imageData: photo)
                    } else {
                        Thumbnail(imageData: UIImage().jpegData(compressionQuality: 0.8)!)
                    }
                }
            }
        }
        .frame(width: imageSize, height: imageSize)
        .background(Color.gray)
        .cornerRadius(Dimensions.radius)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}

struct PhotoThumbNailView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            PhotoThumbNailView(photo: .sample)
                .padding()
                .previewLayout(.sizeThatFits)
        )
    }
}
