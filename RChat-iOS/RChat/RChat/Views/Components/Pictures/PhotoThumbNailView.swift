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
                    Image(uiImage: UIImage(data: photo) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                } else {
                    if let photo = photo.picture {
                        Image(uiImage: UIImage(data: photo) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    } else {
                        Image(uiImage: UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    }
                }
            }
        }
        .frame(width: imageSize, height: imageSize)
        .background(Color.gray)
        .cornerRadius(Dimensions.radius)
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
