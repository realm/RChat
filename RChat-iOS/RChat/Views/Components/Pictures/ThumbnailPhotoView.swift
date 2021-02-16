//
//  ThumbnailPhotoView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct ThumbnailPhotoView: View {
    let photo: Photo
    var imageSize: CGFloat = 64
    
    var body: some View {
        let mugShot = UIImage(data: photo.thumbNail!)
        Image(uiImage: mugShot ?? UIImage())
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageSize, height: imageSize)
    }
}

struct ThumbnailPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(ThumbnailPhotoView(photo: .sample))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
